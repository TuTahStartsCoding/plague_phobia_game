extends Node2D

@onready var area: Area2D = $Area2D
@onready var interaction_prompt: Label = $InteractionPrompt
@onready var prayer_ui: Control = $PrayerUI
@onready var progress_bar: ProgressBar = $PrayerUI/ProgressBar
@onready var instruction_label: Label = $PrayerUI/InstructionLabel
@onready var game_manager = get_node("/root/GameManager")

var is_player_in_temple: bool = false
var is_praying: bool = false
var prayer_time: float = 0.0
var required_prayer_time: float = 5.0

func _ready():
	interaction_prompt.visible = false
	prayer_ui.visible = false
	area.add_to_group("interactable")
	
	if progress_bar:
		progress_bar.max_value = required_prayer_time

func _process(delta):
	if is_praying:
		if Input.is_action_pressed("interact"):
			prayer_time += delta
			update_prayer_progress()
			
			if prayer_time >= required_prayer_time:
				complete_prayer()
		else:
			# Reset if player stops praying
			if prayer_time > 0:
				instruction_label.text = "กด E ค้างไว้เพื่อสวดมนต์"
				instruction_label.modulate = Color.YELLOW

func interact(player):
	if not is_praying and game_manager.hallucination_level > 0:
		start_prayer()
	elif game_manager.hallucination_level <= 0:
		show_message("จิตใจปกติแล้ว")

func start_prayer():
	is_praying = true
	prayer_time = 0.0
	prayer_ui.visible = true
	interaction_prompt.visible = false
	instruction_label.text = "กด E ค้างไว้เพื่อสวดมนต์"
	instruction_label.modulate = Color.WHITE
	
	# Slow down time for player
	get_tree().paused = false  # Keep game running but limit player actions

func update_prayer_progress():
	if progress_bar:
		progress_bar.value = prayer_time
		
		var percentage = (prayer_time / required_prayer_time) * 100
		instruction_label.text = "กำลังสวดมนต์... %.0f%%" % percentage
		instruction_label.modulate = Color.CYAN

func complete_prayer():
	is_praying = false
	prayer_ui.visible = false
	
	# Heal player
	game_manager.pray_at_temple(prayer_time)
	
	# Heal disease if present
	if game_manager.has_disease:
		game_manager.heal_disease()
	
	# Show completion message
	show_message("จิตใจสงบลงแล้ว")
	
	prayer_time = 0.0

func show_prompt(show: bool):
	if show:
		if game_manager.hallucination_level > 0 or game_manager.has_disease:
			interaction_prompt.text = "กด E เพื่อสวดมนต์"
			interaction_prompt.modulate = Color.CYAN
		else:
			interaction_prompt.text = "วัด (จิตใจปกติดี)"
			interaction_prompt.modulate = Color.WHITE
	interaction_prompt.visible = show

func show_message(text: String):
	var label = Label.new()
	label.text = text
	label.position = position + Vector2(0, -60)
	label.modulate = Color.CYAN
	get_parent().add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "position", position + Vector2(0, -90), 2.0)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 2.0)
	tween.tween_callback(label.queue_free)
