extends Node2D

@export var patient_scene: PackedScene
@export var spawn_interval: float = 45.0
@export var max_active_patients: int = 3

var spawn_timer: float = 0.0
var active_patients: int = 0
var spawn_points: Array = []

func _ready():
	# Collect all spawn point children
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child.global_position)
	
	# Spawn initial patients
	spawn_patient()

func _process(delta):
	spawn_timer += delta
	
	if spawn_timer >= spawn_interval and active_patients < max_active_patients:
		spawn_patient()
		spawn_timer = 0.0

func spawn_patient():
	if patient_scene and spawn_points.size() > 0:
		var patient = patient_scene.instantiate()
		var spawn_pos = spawn_points[randi() % spawn_points.size()]
		patient.global_position = spawn_pos
		
		# Connect to patient death/treatment
		patient.tree_exiting.connect(_on_patient_removed)
		
		get_parent().add_child(patient)
		active_patients += 1

func _on_patient_removed():
	active_patients = max(0, active_patients - 1)
