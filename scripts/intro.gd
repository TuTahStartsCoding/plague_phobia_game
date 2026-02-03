extends Control

@onready var story_label: RichTextLabel = $MarginContainer/VBoxContainer/StoryLabel
@onready var continue_button: Button = $MarginContainer/VBoxContainer/ContinueButton
@onready var fade_overlay: ColorRect = $FadeOverlay

var story_text = """
[center][font_size=32]ยุคแห่งโรคระบาด[/font_size][/center]

ในยุคที่โรคอหิวาตกโรคและวัณโรคแพร่ระบาดไปทั่วหมู่บ้าน
ผู้คนนับร้อยนับพันต้องเสียชีวิตไปทุกวัน

คุณคือหมอพื้นบ้านคนสุดท้ายที่ยังมีความรู้เรื่องสมุนไพร
ได้รับมอบหมายให้ออกเดินทางเข้าป่าเพื่อหายาสมุนไพร
นำมารักษาผู้ป่วยที่กำลังรอความช่วยเหลือ

แต่ป่าแห่งนี้ไม่ได้ปลอดภัยเสมอไป...
วิญญาณของผู้เสียชีวิตจากโรคระบาดยังคง徘徊อยู่
น้ำและของเสียที่ปนเปื้อนอาจทำให้คุณติดเชื้อ
และทุกครั้งที่ผู้ป่วยเสียชีวิต...
จิตใจของคุณจะถูกหลอกหลอนมากขึ้น

[center][wave]คุณจะสามารถรักษาผู้คนได้ทันเวลา
และค้นพบยารักษาโรคระบาดก่อนที่จะสายเกินไปหรือไม่?[/wave][/center]
"""

func _ready():
	story_label.bbcode_enabled = true
	story_label.text = story_text
	continue_button.pressed.connect(_on_continue_pressed)
	
	# Start with fade in
	fade_overlay.color = Color.BLACK
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 0.0, 2.0)

func _on_continue_pressed():
	# Fade out and load game
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 1.5)
	tween.tween_callback(start_game)

func start_game():
	var game_manager = get_node("/root/GameManager")
	game_manager.start_new_game()
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
