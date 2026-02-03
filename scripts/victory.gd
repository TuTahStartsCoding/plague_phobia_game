extends Control

@onready var victory_label: Label = $VBoxContainer/VictoryLabel
@onready var story_label: RichTextLabel = $VBoxContainer/StoryLabel
@onready var stats_label: Label = $VBoxContainer/StatsLabel
@onready var menu_button: Button = $VBoxContainer/MenuButton

var victory_story = """
[center]หลังจากวันเวลาที่ยาวนาน
คุณได้สังเกตเห็นรูปแบบของสมุนไพรที่ช่วยรักษาผู้ป่วยได้ดี

ด้วยความรู้และประสบการณ์ที่สั่งสมมา
คุณได้ค้นพบสูตรยารักษาโรคระบาดขึ้นมาได้!

ผู้คนในหมู่บ้านได้รับการรักษาและหายจากโรค
โรคระบาดค่อยๆ หายไปจากหมู่บ้าน

[wave]คุณได้กลายเป็นวีรบุรุษผู้ช่วยชีวิตผู้คนนับร้อย![/wave][/center]
"""

func _ready():
	var game_manager = get_node("/root/GameManager")
	
	story_label.bbcode_enabled = true
	story_label.text = victory_story
	
	# Display stats
	var stats = """
	จำนวนวันที่ใช้: %d วัน
	ผู้ป่วยที่รักษาได้: %d คน
	ผู้ป่วยที่เสียชีวิต: %d คน
	อัตราความสำเร็จ: %.1f%%
	""" % [
		game_manager.current_day - 1,
		game_manager.patients_saved,
		game_manager.patients_dead,
		(float(game_manager.patients_saved) / (game_manager.patients_saved + game_manager.patients_dead)) * 100.0
	]
	
	stats_label.text = stats
	
	menu_button.pressed.connect(_on_menu_pressed)

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
