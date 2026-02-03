extends Control

@onready var game_over_label: Label = $VBoxContainer/GameOverLabel
@onready var stats_label: Label = $VBoxContainer/StatsLabel
@onready var retry_button: Button = $VBoxContainer/RetryButton
@onready var menu_button: Button = $VBoxContainer/MenuButton

func _ready():
	var game_manager = get_node("/root/GameManager")
	
	# Display stats
	var stats = """
	วันที่รอด: %d/%d
	ผู้ป่วยที่รักษาได้: %d
	ผู้ป่วยที่เสียชีวิต: %d
	สภาพจิตใจสุดท้าย: %.1f%%
	ระดับภาพหลอน: %.1f%%
	""" % [
		game_manager.current_day - 1,
		game_manager.max_days,
		game_manager.patients_saved,
		game_manager.patients_dead,
		game_manager.mental_health,
		game_manager.hallucination_level
	]
	
	stats_label.text = stats
	
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func _on_retry_pressed():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
