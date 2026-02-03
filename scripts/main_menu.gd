extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var title_label: Label = $VBoxContainer/TitleLabel

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	
	# Style
	title_label.add_theme_font_size_override("font_size", 48)

func _on_start_button_pressed():
	# Start game with intro
	get_tree().change_scene_to_file("res://scenes/intro.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
