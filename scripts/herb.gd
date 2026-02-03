extends Node2D

@export var herb_type: String = "mint"
@export var respawn_time: float = 60.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var interaction_prompt: Label = $InteractionPrompt
@onready var game_manager = get_node("/root/GameManager")

var is_collected: bool = false
var respawn_timer: float = 0.0

func _ready():
	interaction_prompt.visible = false
	area.add_to_group("interactable")

func _process(delta):
	if is_collected:
		respawn_timer += delta
		if respawn_timer >= respawn_time:
			respawn()

func interact(player):
	if not is_collected:
		collect()

func collect():
	is_collected = true
	sprite.visible = false
	area.monitoring = false
	interaction_prompt.visible = false
	respawn_timer = 0.0
	
	# Add herb to inventory
	game_manager.collect_herb(herb_type)
	
	# Visual feedback
	var label = Label.new()
	label.text = "+" + herb_type
	label.position = position + Vector2(0, -20)
	label.modulate = Color.GREEN
	get_parent().add_child(label)
	
	# Animate and remove label
	var tween = create_tween()
	tween.tween_property(label, "position", position + Vector2(0, -50), 1.0)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.0)
	tween.tween_callback(label.queue_free)

func respawn():
	is_collected = false
	sprite.visible = true
	area.monitoring = true
	respawn_timer = 0.0

func show_prompt(show: bool):
	interaction_prompt.visible = show and not is_collected
