extends Area2D

@export var damage_per_second: float = 5.0
@export var disease_chance: float = 0.5

@onready var game_manager = get_node("/root/GameManager")

var players_inside: Array = []
var damage_timer: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta):
	if players_inside.size() > 0:
		damage_timer += delta
		
		if damage_timer >= 1.0: # Damage every second
			for player in players_inside:
				apply_hazard_effect(player)
			damage_timer = 0.0

func _on_body_entered(body):
	if body.is_in_group("player"):
		players_inside.append(body)
		show_warning(body)

func _on_body_exited(body):
	if body.is_in_group("player"):
		players_inside.erase(body)

func apply_hazard_effect(player):
	# Deal damage
	game_manager.mental_health -= damage_per_second
	game_manager.emit_signal("mental_health_changed", game_manager.mental_health)
	
	# Chance to contract disease
	if not game_manager.has_disease and randf() < disease_chance * 0.1:
		game_manager.contract_disease()
		show_disease_message(player)
	
	# Visual feedback
	if player.has_method("take_damage"):
		player.take_damage(0) # Just for visual effect

func show_warning(player):
	var label = Label.new()
	label.text = "⚠ บริเวณอันตราย!"
	label.position = player.global_position + Vector2(0, -40)
	label.modulate = Color.ORANGE
	get_tree().root.add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "position", player.global_position + Vector2(0, -70), 2.0)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 2.0)
	tween.tween_callback(label.queue_free)

func show_disease_message(player):
	var label = Label.new()
	label.text = "ติดเชื้อโรค!"
	label.position = player.global_position + Vector2(0, -50)
	label.modulate = Color.RED
	label.add_theme_font_size_override("font_size", 20)
	get_tree().root.add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "position", player.global_position + Vector2(0, -80), 2.5)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 2.5)
	tween.tween_callback(label.queue_free)
