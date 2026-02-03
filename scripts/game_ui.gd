extends CanvasLayer

@onready var day_label: Label = $MarginContainer/VBoxContainer/TopBar/DayLabel
@onready var patients_label: Label = $MarginContainer/VBoxContainer/TopBar/PatientsLabel
@onready var mental_health_bar: ProgressBar = $MarginContainer/VBoxContainer/TopBar/MentalHealthBar
@onready var hallucination_bar: ProgressBar = $MarginContainer/VBoxContainer/TopBar/HallucinationBar
@onready var herbs_label: Label = $MarginContainer/VBoxContainer/BottomBar/HerbsLabel
@onready var disease_warning: Label = $MarginContainer/VBoxContainer/DiseaseWarning
@onready var game_manager = get_node("/root/GameManager")

func _ready():
	# Connect signals
	game_manager.day_changed.connect(_on_day_changed)
	game_manager.patient_saved.connect(_on_patient_saved)
	game_manager.patient_died.connect(_on_patient_died)
	game_manager.mental_health_changed.connect(_on_mental_health_changed)
	game_manager.disease_contracted.connect(_on_disease_contracted)
	game_manager.herbs_updated.connect(_on_herbs_updated)
	
	# Initialize UI
	update_ui()
	disease_warning.visible = false

func _process(delta):
	update_ui()
	
	# Flash disease warning
	if game_manager.has_disease:
		disease_warning.visible = true
		var alpha = (sin(Time.get_ticks_msec() * 0.005) + 1.0) / 2.0
		disease_warning.modulate.a = alpha * 0.8 + 0.2
	else:
		disease_warning.visible = false

func update_ui():
	# Update day
	day_label.text = "วันที่: %d/%d" % [game_manager.current_day, game_manager.max_days]
	
	# Update patients
	patients_label.text = "ผู้ป่วย: รักษาแล้ว %d | เสียชีวิต %d" % [
		game_manager.patients_saved,
		game_manager.patients_dead
	]
	
	# Update mental health
	mental_health_bar.value = game_manager.mental_health
	mental_health_bar.modulate = get_health_color(game_manager.mental_health)
	
	# Update hallucination
	hallucination_bar.value = game_manager.hallucination_level
	hallucination_bar.modulate = get_hallucination_color(game_manager.hallucination_level)
	
	# Update herbs
	var herbs_text = "สมุนไพร: "
	for herb_type in game_manager.herbs_collected.keys():
		var amount = game_manager.herbs_collected[herb_type]
		herbs_text += "%s(%d) " % [herb_type, amount]
	herbs_text += "| รวม: %d (ต้องการ %d ต่อคน)" % [
		game_manager.get_total_herbs(),
		game_manager.herbs_required_per_patient
	]
	herbs_label.text = herbs_text

func get_health_color(health: float) -> Color:
	if health > 70:
		return Color.GREEN
	elif health > 30:
		return Color.YELLOW
	else:
		return Color.RED

func get_hallucination_color(level: float) -> Color:
	if level < 30:
		return Color.GREEN
	elif level < 60:
		return Color.YELLOW
	else:
		return Color.RED

func _on_day_changed(day: int):
	show_message("วันที่ %d เริ่มต้น!" % day, Color.CYAN, 3.0)

func _on_patient_saved():
	show_message("รักษาผู้ป่วยสำเร็จ!", Color.GREEN, 2.0)

func _on_patient_died():
	show_message("ผู้ป่วยเสียชีวิต...", Color.RED, 2.0)

func _on_mental_health_changed(value: float):
	# Visual screen effect based on mental health
	var overlay = get_node_or_null("../ScreenOverlay")
	if overlay and overlay is ColorRect:
		var darkness = 1.0 - (value / 100.0)
		overlay.modulate.a = darkness * 0.3

func _on_disease_contracted():
	disease_warning.text = "⚠ ติดเชื้อโรค! เข้าวัดเพื่อรักษา! ⚠"
	show_message("คุณติดเชื้อโรค! รีบไปวัดรักษาตัว!", Color.RED, 3.0)

func _on_herbs_updated():
	# Just trigger update
	pass

func show_message(text: String, color: Color, duration: float):
	var label = Label.new()
	label.text = text
	label.position = Vector2(640, 200)
	label.modulate = color
	label.add_theme_font_size_override("font_size", 24)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "position:y", 150, duration)
	tween.parallel().tween_property(label, "modulate:a", 0.0, duration)
	tween.tween_callback(label.queue_free)
