extends Node2D

@export var treatment_time_limit: float = 30.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var interaction_prompt: Label = $InteractionPrompt
@onready var timer_label: Label = $TimerLabel
@onready var game_manager = get_node("/root/GameManager")

var is_waiting_treatment: bool = true
var timer: float = 0.0
var is_player_nearby: bool = false

func _ready():
	interaction_prompt.visible = false
	timer_label.visible = true
	area.add_to_group("interactable")
	sprite.modulate = Color(1.0, 0.8, 0.8) # Sick appearance

func _process(delta):
	if is_waiting_treatment:
		timer += delta
		update_timer_display()
		
		# Check if time's up
		if timer >= treatment_time_limit:
			patient_dies()

func update_timer_display():
	var time_left = treatment_time_limit - timer
	timer_label.text = "เวลา: %.1f วินาที" % time_left
	
	# Change color based on urgency
	if time_left < 10:
		timer_label.modulate = Color.RED
	elif time_left < 20:
		timer_label.modulate = Color.YELLOW
	else:
		timer_label.modulate = Color.WHITE

func interact(player):
	if is_waiting_treatment:
		if game_manager.can_treat_patient():
			treat_patient()
		else:
			show_not_enough_herbs()

func treat_patient():
	is_waiting_treatment = false
	game_manager.treat_patient(true)
	
	# Visual feedback
	sprite.modulate = Color.GREEN
	timer_label.text = "รักษาสำเร็จ!"
	timer_label.modulate = Color.GREEN
	interaction_prompt.visible = false
	
	# Remove after animation
	await get_tree().create_timer(2.0).timeout
	queue_free()

func patient_dies():
	is_waiting_treatment = false
	game_manager.treat_patient(false)
	
	# Visual feedback
	sprite.modulate = Color(0.3, 0.3, 0.3)
	timer_label.text = "เสียชีวิต..."
	timer_label.modulate = Color.DARK_GRAY
	interaction_prompt.visible = false
	
	# Spawn hallucination effect
	spawn_death_effect()
	
	# Remove after animation
	await get_tree().create_timer(3.0).timeout
	queue_free()

func spawn_death_effect():
	# Create visual effect for patient death
	var effect = ColorRect.new()
	effect.color = Color(0.5, 0, 0, 0.3)
	effect.size = Vector2(100, 100)
	effect.position = position - effect.size / 2
	get_parent().add_child(effect)
	
	var tween = create_tween()
	tween.tween_property(effect, "modulate:a", 0.0, 2.0)
	tween.tween_callback(effect.queue_free)

func show_not_enough_herbs():
	var label = Label.new()
	label.text = "ยาสมุนไพรไม่พอ!"
	label.position = position + Vector2(0, -40)
	label.modulate = Color.RED
	get_parent().add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "position", position + Vector2(0, -70), 1.5)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.5)
	tween.tween_callback(label.queue_free)

func show_prompt(show: bool):
	if is_waiting_treatment:
		if show:
			if game_manager.can_treat_patient():
				interaction_prompt.text = "กด E เพื่อรักษา"
				interaction_prompt.modulate = Color.GREEN
			else:
				interaction_prompt.text = "ยาสมุนไพรไม่พอ"
				interaction_prompt.modulate = Color.RED
		interaction_prompt.visible = show
