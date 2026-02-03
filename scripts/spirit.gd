extends CharacterBody2D

@export var wander_speed: float = 50.0
@export var chase_speed: float = 100.0
@export var detection_range: float = 200.0
@export var damage_cooldown: float = 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var collision_shape: CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var game_manager = get_node("/root/GameManager")

enum State {
	WANDER,
	CHASE,
	ATTACK
}

var current_state: State = State.WANDER
var player: CharacterBody2D = null
var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0
var damage_timer: float = 0.0

func _ready():
	sprite.play("float")
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)
	
	# Set detection radius
	if collision_shape.shape is CircleShape2D:
		collision_shape.shape.radius = detection_range
	
	change_wander_direction()

func _physics_process(delta):
	damage_timer += delta
	
	match current_state:
		State.WANDER:
			wander(delta)
		State.CHASE:
			chase_player(delta)
		State.ATTACK:
			attack_player(delta)
	
	move_and_slide()
	
	# Fade effect based on hallucination level
	var alpha = 0.3 + (game_manager.hallucination_level / 100.0) * 0.7
	modulate.a = alpha

func wander(delta):
	wander_timer += delta
	
	if wander_timer >= 3.0:
		change_wander_direction()
		wander_timer = 0.0
	
	velocity = wander_direction * wander_speed

func chase_player(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * chase_speed
		
		# Check if close enough to attack
		if global_position.distance_to(player.global_position) < 30.0:
			current_state = State.ATTACK

func attack_player(delta):
	if player and damage_timer >= damage_cooldown:
		game_manager.encounter_spirit()
		damage_timer = 0.0
		
		# Push player back
		var knockback = (player.global_position - global_position).normalized() * 200.0
		player.velocity = knockback
	
	if not player or global_position.distance_to(player.global_position) > 30.0:
		current_state = State.CHASE

func change_wander_direction():
	wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _on_detection_area_entered(body):
	if body.is_in_group("player"):
		player = body
		current_state = State.CHASE

func _on_detection_area_exited(body):
	if body == player:
		player = null
		current_state = State.WANDER
		change_wander_direction()
