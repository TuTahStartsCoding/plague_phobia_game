# คู่มือการสร้าง Scenes ใน Godot 4

## 1. Main Menu Scene (main_menu.tscn)

### โครงสร้าง Node:
```
Control (main_menu.gd)
└── VBoxContainer
	├── TitleLabel
	├── StartButton
	└── QuitButton
```

### การตั้งค่า:
1. สร้าง Control node และแนบ script main_menu.gd
2. เพิ่ม VBoxContainer:
   - Layout → Center Container
   - Anchor Preset → Center
3. เพิ่ม Label สำหรับชื่อเกม:
   - Text: "PLAGUE PHOBIA"
   - Font Size: 48
4. เพิ่ม Buttons และตั้งชื่อ

---

## 2. Intro Scene (intro.tscn)

### โครงสร้าง Node:
```
Control (intro.gd)
├── MarginContainer
│   └── VBoxContainer
│       ├── StoryLabel (RichTextLabel)
│       └── ContinueButton
└── FadeOverlay (ColorRect)
```

### การตั้งค่า:
1. สร้าง Control node และแนบ script intro.gd
2. MarginContainer → Full Rect
3. RichTextLabel:
   - BBCode Enabled: On
   - Scroll Active: On
4. FadeOverlay:
   - Full Rect
   - Color: Black
   - Mouse Filter: Ignore

---

## 3. Main Game Scene (main_game.tscn)

### โครงสร้าง Node:
```
Node2D (main_game)
├── TileMap (แผนที่ป่า/หมู่บ้าน/วัด)
├── Player (CharacterBody2D)
│   ├── AnimatedSprite2D
│   ├── CollisionShape2D
│   └── InteractionArea (Area2D)
│       └── CollisionShape2D
├── Forest (Node2D)
│   ├── Herb_Mint (Node2D + herb.gd)
│   │   ├── Sprite2D
│   │   ├── Area2D
│   │   │   └── CollisionShape2D
│   │   └── InteractionPrompt (Label)
│   └── Herb_Ginger (เหมือนกัน)
├── Village (Node2D)
│   ├── PatientSpawner (Node2D + patient_spawner.gd)
│   │   ├── SpawnPoint1 (Marker2D)
│   │   └── SpawnPoint2 (Marker2D)
│   └── House (Sprite2D)
├── Temple (Node2D + temple.gd)
│   ├── Sprite2D
│   ├── Area2D
│   │   └── CollisionShape2D
│   ├── InteractionPrompt (Label)
│   └── PrayerUI (Control)
│       ├── ProgressBar
│       └── InstructionLabel
├── Spirits (Node2D)
│   └── Spirit (CharacterBody2D + spirit.gd)
│       ├── AnimatedSprite2D
│       ├── CollisionShape2D
│       └── DetectionArea (Area2D)
│           └── CollisionShape2D
├── HazardAreas (Node2D)
│   └── DirtyWater (Area2D + hazard_area.gd)
│       ├── CollisionShape2D
│       └── Sprite2D (สีน้ำตาล/เขียวมะกอก)
├── Camera2D (follow player)
├── GameUI (CanvasLayer + game_ui.gd)
│   └── MarginContainer
│       └── VBoxContainer
│           ├── TopBar (HBoxContainer)
│           │   ├── DayLabel
│           │   ├── PatientsLabel
│           │   ├── MentalHealthBar (ProgressBar)
│           │   └── HallucinationBar (ProgressBar)
│           ├── DiseaseWarning (Label)
│           └── BottomBar (HBoxContainer)
│               └── HerbsLabel
└── ScreenOverlay (ColorRect)
```

### การตั้งค่าแต่ละ Node:

#### Player
1. CharacterBody2D + script player.gd
2. AnimatedSprite2D:
   - สร้าง animations: walk_up, walk_down, walk_left, walk_right
   - idle_up, idle_down, idle_left, idle_right
3. CollisionShape2D: CapsuleShape2D (16x24)
4. InteractionArea:
   - CollisionShape2D: CircleShape2D (radius: 32)
   - เชื่อม signal body_entered/exited กับ player script

#### Herb
1. Node2D + script herb.gd
2. Sprite2D: texture ของสมุนไพร
3. Area2D:
   - Add to group: "interactable"
   - CollisionShape2D: CircleShape2D (radius: 16)
4. InteractionPrompt:
   - Text: "กด E เพื่อเก็บ"
   - Position: (0, -20)
   - Visible: false

#### Patient
1. Node2D + script patient.gd
2. Sprite2D: texture ของผู้ป่วย
3. Area2D + CollisionShape2D
4. InteractionPrompt (Label)
5. TimerLabel (Label)

#### Temple
1. Node2D + script temple.gd
2. Sprite2D: texture วัด (32x32 หรือใหญ่กว่า)
3. Area2D:
   - Add to group: "interactable"
   - CollisionShape2D: RectangleShape2D
4. PrayerUI:
   - Control node
   - Visible: false
   - ProgressBar + Label

#### Spirit
1. CharacterBody2D + script spirit.gd
2. AnimatedSprite2D:
   - Animation: float (animation วิญญาณลอย)
   - Modulate: alpha 0.5-0.8
3. CollisionShape2D: CapsuleShape2D
4. DetectionArea:
   - CircleShape2D (radius: 200)

#### HazardArea
1. Area2D + script hazard_area.gd
2. CollisionShape2D: RectangleShape2D หรือ shape ตามต้องการ
3. Sprite2D (optional): แสดงพื้นที่อันตราย

#### Camera2D
- Position: (0, 0)
- Enabled: On
- Process Mode: Inherit
- Limit Smoothed: On
- Position Smoothing Enabled: On
- Position Smoothing Speed: 5

#### GameUI
1. CanvasLayer + script game_ui.gd
2. สร้างโครงสร้าง UI ตามด้านบน
3. ProgressBars:
   - Max Value: 100
   - Show Percentage: On
   - Custom Colors ตามประเภท

---

## 4. Game Over Scene (game_over.tscn)

### โครงสร้าง Node:
```
Control (game_over.gd)
└── VBoxContainer
	├── GameOverLabel
	├── StatsLabel
	├── RetryButton
	└── MenuButton
```

---

## 5. Victory Scene (victory.tscn)

### โครงสร้าง Node:
```
Control (victory.gd)
└── VBoxContainer
	├── VictoryLabel
	├── StoryLabel (RichTextLabel)
	├── StatsLabel
	└── MenuButton
```

---

## การตั้งค่า TileMap

### Tileset Setup:
1. สร้าง TileSet ใหม่
2. เพิ่ม texture atlas (16x16 tiles)
3. กำหนด tiles:
   - หญ้า (grass)
   - ดิน (dirt)
   - หิน (stone)
   - น้ำ (water)
   - พื้นวัด (temple floor)
   - พื้นบ้าน (house floor)

### Layers:
1. Ground Layer (0)
2. Decoration Layer (1)
3. Collision Layer (2)

### แผนที่แนะนำ:
```
[วัด]
  |
[ป่า] - [วิญญาณ] - [สมุนไพร]
  |         |
[หมู่บ้าน] - [ผู้ป่วย]
```

---

## การเชื่อม Signals

### GameManager Signals:
- day_changed → GameUI._on_day_changed
- patient_saved → GameUI._on_patient_saved
- patient_died → GameUI._on_patient_died
- mental_health_changed → GameUI._on_mental_health_changed
- disease_contracted → GameUI._on_disease_contracted
- herbs_updated → GameUI._on_herbs_updated
- game_over → เปลี่ยนไปหน้า game_over
- victory → เปลี่ยนไปหน้า victory

---

## Tips การออกแบบ Level

1. **ป่า**: 
   - มืดกว่าหมู่บ้าน
   - มีต้นไม้หนาแน่น
   - จุด spawn สมุนไพรกระจายทั่วพื้นที่
   - วิญญาณเดินเตร็ดเตร่

2. **หมู่บ้าน**:
   - สว่าง ปลอดภัย
   - มีบ้านเรือน
   - จุด spawn ผู้ป่วย

3. **วัด**:
   - อยู่ตรงกลางหรือด้านบน
   - มีบรรยากาศสงบ
   - พื้นที่โล่งไม่มีอันตราย

4. **พื้นที่อันตราย**:
   - บริเวณขอบน้ำ
   - พื้นที่ชื้น
   - มีสีเขียวมะกอก/น้ำตาล

---

## การทดสอบเกม

### Checklist:
- [ ] เคลื่อนที่ผู้เล่นได้ทุกทิศทาง
- [ ] เก็บสมุนไพรได้
- [ ] รักษาผู้ป่วยได้
- [ ] ผู้ป่วยเสียชีวิตเมื่อหมดเวลา
- [ ] วิญญาณไล่ตามได้
- [ ] พื้นที่อันตรายทำงาน
- [ ] วัดรักษาจิตใจได้
- [ ] UI แสดงค่าถูกต้อง
- [ ] เปลี่ยน scene ได้
- [ ] ชนะเกมเมื่อครบ 7 วัน
- [ ] แพ้เกมเมื่อสุขภาพจิตหมด

---

## Debug Mode (Optional)

เพิ่มในสคริปต์ player.gd:
```gdscript
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and OS.is_debug_build():
		# Debug commands
		if Input.is_key_pressed(KEY_1):
			game_manager.collect_herb("mint")
		if Input.is_key_pressed(KEY_2):
			game_manager.mental_health = 100
```

ใช้เพื่อทดสอบเกมได้เร็วขึ้น
