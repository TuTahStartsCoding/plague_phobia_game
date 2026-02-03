extends Node

# Game States
enum GameState {
	MENU,
	INTRO,
	GAMEPLAY,
	IN_TEMPLE,
	GAME_OVER,
	VICTORY
}

# Game Statistics
var current_state: GameState = GameState.MENU
var current_day: int = 1
var max_days: int = 7
var patients_saved: int = 0
var patients_dead: int = 0
var required_saves_per_day: int = 3
var mental_health: float = 100.0
var has_disease: bool = false
var disease_timer: float = 0.0

# Herb Collection
var herbs_collected: Dictionary = {
	"mint": 0,
	"ginger": 0,
	"turmeric": 0,
	"garlic": 0
}

var herbs_required_per_patient: int = 3

# Hallucination System
var hallucination_level: float = 0.0
var max_hallucination: float = 100.0

# Signals
signal day_changed(day: int)
signal patient_saved()
signal patient_died()
signal mental_health_changed(value: float)
signal disease_contracted()
signal game_over()
signal victory()
signal herbs_updated()

func _ready():
	pass

func start_new_game():
	current_day = 1
	patients_saved = 0
	patients_dead = 0
	mental_health = 100.0
	hallucination_level = 0.0
	has_disease = false
	disease_timer = 0.0
	herbs_collected = {
		"mint": 0,
		"ginger": 0,
		"turmeric": 0,
		"garlic": 0
	}
	current_state = GameState.INTRO

func _process(delta):
	if current_state == GameState.GAMEPLAY:
		# Update disease timer
		if has_disease:
			disease_timer += delta
			if disease_timer >= 30.0: # 30 seconds to treat
				mental_health -= 10.0
				disease_timer = 0.0
				emit_signal("mental_health_changed", mental_health)
				check_game_over()

func collect_herb(herb_type: String):
	if herbs_collected.has(herb_type):
		herbs_collected[herb_type] += 1
		emit_signal("herbs_updated")

func can_treat_patient() -> bool:
	var total_herbs = 0
	for herb in herbs_collected.values():
		total_herbs += herb
	return total_herbs >= herbs_required_per_patient

func treat_patient(success: bool):
	if success:
		# Use herbs
		var herbs_used = 0
		for herb_type in herbs_collected.keys():
			while herbs_collected[herb_type] > 0 and herbs_used < herbs_required_per_patient:
				herbs_collected[herb_type] -= 1
				herbs_used += 1
		
		patients_saved += 1
		emit_signal("patient_saved")
		emit_signal("herbs_updated")
		
		# Check if day complete
		if patients_saved >= required_saves_per_day * current_day:
			next_day()
	else:
		patients_dead += 1
		hallucination_level += 20.0
		mental_health -= 15.0
		emit_signal("patient_died")
		emit_signal("mental_health_changed", mental_health)
		
		# Force temple visit
		if hallucination_level >= 50.0:
			current_state = GameState.IN_TEMPLE
		
		check_game_over()

func contract_disease():
	has_disease = true
	disease_timer = 0.0
	emit_signal("disease_contracted")

func heal_disease():
	has_disease = false
	disease_timer = 0.0

func encounter_spirit():
	hallucination_level += 30.0
	mental_health -= 20.0
	current_state = GameState.IN_TEMPLE
	emit_signal("mental_health_changed", mental_health)

func pray_at_temple(duration: float):
	var healing = duration * 5.0 # Heal 5 points per second of prayer
	hallucination_level = max(0, hallucination_level - healing)
	mental_health = min(100.0, mental_health + healing * 0.5)
	emit_signal("mental_health_changed", mental_health)
	
	if hallucination_level < 20.0:
		current_state = GameState.GAMEPLAY

func next_day():
	current_day += 1
	emit_signal("day_changed", current_day)
	
	if current_day > max_days:
		# Victory condition - discovered medicine
		emit_signal("victory")
		current_state = GameState.VICTORY
	else:
		# Reset daily progress
		hallucination_level = max(0, hallucination_level - 10.0)

func check_game_over():
	if mental_health <= 0 or hallucination_level >= max_hallucination:
		current_state = GameState.GAME_OVER
		emit_signal("game_over")

func get_total_herbs() -> int:
	var total = 0
	for amount in herbs_collected.values():
		total += amount
	return total
