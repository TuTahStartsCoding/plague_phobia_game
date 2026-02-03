extends CharacterBody2D

# Movement
@export var speed: float = 150.0
@export var sprint_multiplier: float = 1.5

# References
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var game_manager = get_node("/root/GameManager")

# Player state
var is_sprinting: bool = false
var is_in_interaction_zone: bool = false
var current_interaction_object = null

func _ready():
	pass

func _physics_process(delta):
	handle_input()
	handle_movement(delta)
	update_animation()

func handle_input():
	# Sprint
	is_sprinting = Input.is_action_pressed("sprint")
	
	# Interact
	if Input.is_action_just_pressed("interact") and current_interaction_object:
		interact_with_object()

func handle_movement(delta):
	# Get input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Calculate velocity
	if input_dir != Vector2.ZERO:
		var move_speed = speed
		if is_sprinting and game_manager.mental_health > 30:
			move_speed *= sprint_multiplier
		
		velocity = input_dir.normalized() * move_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * 3 * delta)
	
	move_and_slide()

func update_animation():
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				sprite.play("walk_right")
			else:
				sprite.play("walk_left")
		else:
			if velocity.y > 0:
				sprite.play("walk_down")
			else:
				sprite.play("walk_up")
	else:
		if sprite.animation.begins_with("walk_"):
			var direction = sprite.animation.replace("walk_", "idle_")
			sprite.play(direction)

func interact_with_object():
	if current_interaction_object.has_method("interact"):
		current_interaction_object.interact(self)

func _on_interaction_area_entered(area):
	if area.is_in_group("interactable"):
		is_in_interaction_zone = true
		current_interaction_object = area.get_parent()
		# Show interaction prompt
		if current_interaction_object.has_method("show_prompt"):
			current_interaction_object.show_prompt(true)

func _on_interaction_area_exited(area):
	if area.is_in_group("interactable"):
		is_in_interaction_zone = false
		if current_interaction_object and current_interaction_object.has_method("show_prompt"):
			current_interaction_object.show_prompt(false)
		current_interaction_object = null

func take_damage(amount: float):
	game_manager.mental_health -= amount
	game_manager.emit_signal("mental_health_changed", game_manager.mental_health)
	# Visual feedback
	modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.2).timeout
	modulate = Color(1, 1, 1)
