# คู่มือการปรับแต่งและขยายเกม

## 🎮 การ Balance เกม

### ค่าที่สามารถปรับได้

#### ใน game_manager.gd:
```gdscript
var max_days: int = 7                    # จำนวนวันทั้งหมด (7-14 วันแนะนำ)
var required_saves_per_day: int = 3      # ผู้ป่วยต่อวัน (2-5 คนแนะนำ)
var herbs_required_per_patient: int = 3  # สมุนไพรต่อคน (2-5 แนะนำ)
var max_hallucination: float = 100.0     # ระดับภาพหลอนสูงสุด
```

#### ใน player.gd:
```gdscript
@export var speed: float = 150.0              # ความเร็วเดิน (100-200)
@export var sprint_multiplier: float = 1.5    # ตัวคูณวิ่ง (1.3-2.0)
```

#### ใน herb.gd:
```gdscript
@export var respawn_time: float = 60.0  # เวลา respawn สมุนไพร (30-120 วินาที)
```

#### ใน patient.gd:
```gdscript
@export var treatment_time_limit: float = 30.0  # เวลาในการรักษา (20-60 วินาที)
```

#### ใน spirit.gd:
```gdscript
@export var wander_speed: float = 50.0        # ความเร็วเดินเตร่ (30-70)
@export var chase_speed: float = 100.0        # ความเร็วไล่ล่า (80-150)
@export var detection_range: float = 200.0    # ระยะตรวจจับ (150-300)
```

#### ใน hazard_area.gd:
```gdscript
@export var damage_per_second: float = 5.0    # ความเสียหายต่อวินาที (3-10)
@export var disease_chance: float = 0.5       # โอกาสติดโรค (0.3-0.8)
```

---

## 🌟 คุณสมบัติเพิ่มเติมที่แนะนำ

### 1. ระบบ Inventory ขั้นสูง
```gdscript
# เพิ่มใน game_manager.gd
var max_herb_capacity: int = 20
var herb_combinations: Dictionary = {
    "cure_plague": ["mint", "ginger", "turmeric"],
    "cure_tuberculosis": ["garlic", "turmeric", "mint"]
}
```

### 2. ระบบ Day/Night Cycle
```gdscript
# สร้างไฟล์ใหม่: day_night_cycle.gd
extends Node

var time_of_day: float = 0.0  # 0-24
var day_length: float = 300.0  # 5 นาที = 1 วัน

func _process(delta):
    time_of_day += delta / day_length * 24
    if time_of_day >= 24:
        time_of_day = 0
    update_lighting()

func update_lighting():
    # ปรับแสงตามเวลา
    pass
```

### 3. ระบบ Upgrade/Skills
```gdscript
# เพิ่มใน game_manager.gd
var player_skills: Dictionary = {
    "faster_collection": false,  # เก็บสมุนไพรเร็วขึ้น
    "better_medicine": false,    # ใช้สมุนไพรน้อยลง
    "mental_resistance": false,  # ต้านทานภาพหลอนดีขึ้น
    "spirit_vision": false       # มองเห็นวิญญาณได้ไกลขึ้น
}
```

### 4. ระบบ Crafting
```gdscript
var crafting_recipes: Dictionary = {
    "basic_medicine": {
        "herbs": {"mint": 2, "ginger": 1},
        "effectiveness": 0.7
    },
    "advanced_medicine": {
        "herbs": {"mint": 2, "ginger": 2, "turmeric": 1},
        "effectiveness": 1.0
    }
}
```

### 5. ระบบ Quest/Mission
```gdscript
var active_quests: Array = [
    {
        "name": "หายาด่วน",
        "type": "collect_herbs",
        "target": 10,
        "reward": "faster_collection"
    }
]
```

---

## 🎨 การเพิ่ม Visual Effects

### 1. Screen Shake
```gdscript
# เพิ่มใน Camera2D
func shake(intensity: float, duration: float):
    var original_pos = offset
    var shake_tween = create_tween()
    
    for i in range(int(duration * 60)):  # 60 FPS
        var shake_offset = Vector2(
            randf_range(-intensity, intensity),
            randf_range(-intensity, intensity)
        )
        shake_tween.tween_property(self, "offset", shake_offset, 0.016)
    
    shake_tween.tween_property(self, "offset", original_pos, 0.1)
```

### 2. Vignette Effect
```gdscript
# สร้าง shader vignette.gdshader
shader_type canvas_item;

uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec2 uv = UV - 0.5;
    float dist = length(uv);
    float vignette = 1.0 - smoothstep(0.3, 0.8, dist);
    COLOR.rgb *= mix(1.0, vignette, vignette_intensity);
}
```

### 3. Particle Effects
```gdscript
# เพิ่ม particles เมื่อเก็บสมุนไพร
var particles = GPUParticles2D.new()
particles.amount = 20
particles.lifetime = 1.0
particles.process_material = ParticleProcessMaterial.new()
add_child(particles)
```

---

## 🔊 Sound Effects ที่แนะนำ

### Sound List:
1. **footstep.wav** - เสียงเดิน
2. **herb_collect.wav** - เก็บสมุนไพร
3. **heal_success.wav** - รักษาสำเร็จ
4. **patient_die.wav** - ผู้ป่วยเสียชีวิต
5. **spirit_alert.wav** - วิญญาณตรวจพบผู้เล่น
6. **spirit_attack.wav** - วิญญาณโจมตี
7. **disease_contract.wav** - ติดโรค
8. **prayer_chant.wav** - สวดมนต์
9. **ambient_forest.wav** - เสียงป่า (loop)
10. **ambient_village.wav** - เสียงหมู่บ้าน (loop)
11. **ambient_temple.wav** - เสียงวัด (loop)

### วิธีเพิ่ม Sound:
```gdscript
# สร้าง AudioStreamPlayer2D
var sound_player = AudioStreamPlayer2D.new()
sound_player.stream = load("res://assets/sounds/herb_collect.wav")
add_child(sound_player)
sound_player.play()
```

---

## 🎯 ระบบ Achievement

```gdscript
# เพิ่มใน game_manager.gd
var achievements: Dictionary = {
    "first_save": {
        "name": "ผู้ช่วยชีวิตมือใหม่",
        "description": "รักษาผู้ป่วยครั้งแรก",
        "unlocked": false
    },
    "perfect_day": {
        "name": "วันที่สมบูรณ์แบบ",
        "description": "ผ่าน 1 วันโดยไม่มีผู้ป่วยเสียชีวิต",
        "unlocked": false
    },
    "herb_master": {
        "name": "ปรมาจารย์สมุนไพร",
        "description": "เก็บสมุนไพรครบ 100 ชิ้น",
        "unlocked": false
    },
    "spirit_survivor": {
        "name": "ผู้รอดชีวิต",
        "description": "หลบวิญญาณสำเร็จ 10 ครั้ง",
        "unlocked": false
    },
    "cure_discoverer": {
        "name": "ผู้ค้นพบยา",
        "description": "จบเกมโดยค้นพบยารักษาโรค",
        "unlocked": false
    }
}

func unlock_achievement(achievement_id: String):
    if achievements.has(achievement_id) and not achievements[achievement_id]["unlocked"]:
        achievements[achievement_id]["unlocked"] = true
        show_achievement_popup(achievement_id)
```

---

## 📊 ระบบ Save/Load

```gdscript
# เพิ่มใน game_manager.gd
func save_game():
    var save_data = {
        "current_day": current_day,
        "patients_saved": patients_saved,
        "patients_dead": patients_dead,
        "mental_health": mental_health,
        "herbs_collected": herbs_collected,
        "achievements": achievements
    }
    
    var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
    file.store_var(save_data)
    file.close()

func load_game():
    if not FileAccess.file_exists("user://savegame.save"):
        return false
    
    var file = FileAccess.open("user://savegame.save", FileAccess.READ)
    var save_data = file.get_var()
    file.close()
    
    current_day = save_data["current_day"]
    patients_saved = save_data["patients_saved"]
    # ... load other data
    
    return true
```

---

## 🌐 ระบบ Localization (หลายภาษา)

```gdscript
# สร้าง translation files
# en.translation, th.translation

# ใช้ใน code:
$Label.text = tr("GAME_TITLE")
$Button.text = tr("START_GAME")

# ในไฟล์ en.translation:
# GAME_TITLE = "Plague Phobia"
# START_GAME = "Start Game"

# ในไฟล์ th.translation:
# GAME_TITLE = "โรคระบาดแห่งความหวาดกลัว"
# START_GAME = "เริ่มเกม"
```

---

## 🎲 Random Events

```gdscript
var random_events: Array = [
    {
        "name": "heavy_rain",
        "description": "ฝนตกหนัก เคลื่อนที่ช้าลง",
        "effect": func(): player.speed *= 0.7,
        "duration": 60.0
    },
    {
        "name": "spirit_surge",
        "description": "วิญญาณเพิ่มมากขึ้น",
        "effect": func(): spawn_extra_spirits(3),
        "duration": 30.0
    },
    {
        "name": "herb_abundance",
        "description": "สมุนไพรงอกมากขึ้น",
        "effect": func(): respawn_all_herbs(),
        "duration": 0.0
    }
]

func trigger_random_event():
    if randf() < 0.1:  # 10% chance
        var event = random_events[randi() % random_events.size()]
        apply_event_effect(event)
```

---

## 🏆 Difficulty Levels

```gdscript
enum Difficulty {
    EASY,
    NORMAL,
    HARD,
    NIGHTMARE
}

var difficulty_settings = {
    Difficulty.EASY: {
        "patient_time_limit": 60.0,
        "spirit_speed_multiplier": 0.7,
        "herbs_required": 2,
        "disease_chance": 0.3
    },
    Difficulty.NORMAL: {
        "patient_time_limit": 30.0,
        "spirit_speed_multiplier": 1.0,
        "herbs_required": 3,
        "disease_chance": 0.5
    },
    Difficulty.HARD: {
        "patient_time_limit": 20.0,
        "spirit_speed_multiplier": 1.3,
        "herbs_required": 4,
        "disease_chance": 0.7
    },
    Difficulty.NIGHTMARE: {
        "patient_time_limit": 15.0,
        "spirit_speed_multiplier": 1.5,
        "herbs_required": 5,
        "disease_chance": 0.9
    }
}
```

---

## 📱 Mobile Controls (Optional)

```gdscript
# สร้าง virtual joystick
extends TouchScreenButton

var touch_index = -1
var center_position = Vector2.ZERO

func _ready():
    center_position = position + size / 2

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            touch_index = event.index
            update_joystick(event.position)
        else:
            touch_index = -1
            reset_joystick()
    
    elif event is InputEventScreenDrag and event.index == touch_index:
        update_joystick(event.position)

func update_joystick(touch_pos: Vector2):
    var direction = (touch_pos - center_position).normalized()
    # Send direction to player
```

---

## 🐛 Debug Tools

```gdscript
# เพิ่มใน player.gd
func _unhandled_input(event):
    if not OS.is_debug_build():
        return
    
    # Debug shortcuts
    if event.is_action_pressed("ui_page_up"):
        game_manager.collect_herb("mint")
        game_manager.collect_herb("ginger")
        game_manager.collect_herb("turmeric")
    
    if event.is_action_pressed("ui_page_down"):
        game_manager.mental_health = 100.0
        game_manager.hallucination_level = 0.0
    
    if event.is_action_pressed("ui_home"):
        game_manager.next_day()
    
    if event.is_action_pressed("ui_end"):
        game_manager.patients_saved = 100
```

---

## 📈 Analytics (Optional)

```gdscript
# เพิ่ม analytics tracking
var game_stats = {
    "total_play_time": 0.0,
    "herbs_collected_total": 0,
    "patients_saved_total": 0,
    "deaths": 0,
    "completions": 0
}

func track_event(event_name: String, data: Dictionary = {}):
    # Save to file or send to server
    print("Event: ", event_name, " Data: ", data)
```

---

## 🎬 Cutscenes

```gdscript
# สร้าง cutscene system
extends Node

signal cutscene_finished

func play_cutscene(cutscene_id: String):
    match cutscene_id:
        "game_intro":
            await show_text("ณ ยุคแห่งโรคระบาด...")
            await fade_to_black()
            emit_signal("cutscene_finished")
        "first_death":
            await show_text("ผู้ป่วยเสียชีวิต...")
            await shake_camera()
            emit_signal("cutscene_finished")
```

---

## สรุป

เกมนี้มีศักยภาพในการขยายเป็นเกมขนาดใหญ่ได้มาก! 
เริ่มจากระบบพื้นฐาน แล้วค่อยๆ เพิ่มฟีเจอร์ทีละอย่าง

ขอให้สนุกกับการพัฒนา! 🎮
