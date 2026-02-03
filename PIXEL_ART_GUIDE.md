# คู่มือการสร้าง Pixel Art Sprites

## ขนาด Sprites ที่แนะนำ

### ตัวละคร (Characters)
- **Player**: 16x16 pixels หรือ 32x32 pixels
- **Patient**: 16x16 pixels
- **Spirit**: 16x16 pixels (โปร่งใส 50-80%)

### สิ่งของ (Items)
- **สมุนไพร**: 8x8 pixels หรือ 16x16 pixels
- **อาคาร**: 32x32 pixels ขึ้นไป

### สิ่งแวดล้อม (Environment)
- **Tiles**: 16x16 pixels
- **ต้นไม้**: 16x32 pixels
- **หิน**: 16x16 pixels

---

## Color Palette แนะนำ

### ธีมมืด (Dark Horror)
```
#1a1a2e - Background Dark Blue
#16213e - Dark Blue
#0f3460 - Medium Blue
#533483 - Dark Purple
#8b4367 - Dark Red
#a45a52 - Brown Red
#c38e70 - Light Brown
#e8b4b8 - Pale Pink
```

### ธีมธรรมชาติ (Nature)
```
#2d4a3e - Dark Green
#3e6344 - Forest Green
#8b9556 - Olive Green
#c4c3a5 - Beige
#6b4423 - Dark Brown
#a67c52 - Brown
#d4a574 - Light Brown
#f5e6d3 - Cream
```

### เพิ่มเติม
```
#ffffff - White (highlights)
#cccccc - Light Gray
#888888 - Gray
#444444 - Dark Gray
#000000 - Black (outlines)
```

---

## Animations ที่ต้องการ

### Player Animations
1. **idle_down** (หันหน้าลง): 1-2 frames
2. **idle_up** (หันหน้าขึ้น): 1-2 frames
3. **idle_left** (หันซ้าย): 1-2 frames
4. **idle_right** (หันขวา): 1-2 frames
5. **walk_down**: 4-6 frames
6. **walk_up**: 4-6 frames
7. **walk_left**: 4-6 frames
8. **walk_right**: 4-6 frames

### Spirit Animation
1. **float**: 4-6 frames (ลอยขึ้นลง)
2. **attack**: 2-4 frames (optional)

### Patient Animation
1. **sick**: 1-2 frames (นอนหรือนั่งป่วย)

---

## เครื่องมือแนะนำ

### ฟรี
1. **Aseprite** (Open Source build) - https://github.com/aseprite/aseprite
2. **Piskel** (Web-based) - https://www.piskelapp.com/
3. **LibreSprite** (Free) - https://libresprite.github.io/
4. **GIMP** (Free) - https://www.gimp.org/

### มีค่า
1. **Aseprite** (Official) - https://www.aseprite.org/
2. **Pixaki** (iOS) - For iPad
3. **Pyxel Edit** - https://pyxeledit.com/

---

## Sprite Sheets Layout

### Player Sprite Sheet (128x64 pixels)
```
[idle_down][walk_down_1][walk_down_2][walk_down_3][walk_down_4]
[idle_up]  [walk_up_1]  [walk_up_2]  [walk_up_3]  [walk_up_4]
[idle_left][walk_left_1][walk_left_2][walk_left_3][walk_left_4]
[idle_right][walk_right_1][walk_right_2][walk_right_3][walk_right_4]
```

---

## ตัวอย่างการสร้าง Player Sprite

### Front View (idle_down)
```
	████        (หมวก/ผม)
  ██████████    (หน้า)
  ██  ██  ██    (ตา)
  ██████████    (ใบหน้า)
	██████      (คอ)
  ████████████  (ร่างกาย)
  ████  ████    (แขน)
  ████  ████    
	████████    (ขา)
	██  ██      
```

### Frame Animation Timing
- **Idle**: 500ms per frame
- **Walk**: 150ms per frame
- **Spirit Float**: 300ms per frame

---

## การ Export Sprites

### สำหรับ Godot 4
1. **Format**: PNG (แนะนำ)
2. **Background**: Transparent
3. **Filter**: None (Nearest Neighbor)
4. **Color Mode**: RGBA

### Import Settings ใน Godot
1. **Filter**: Nearest (สำคัญมาก!)
2. **Repeat**: Disabled
3. **Mipmaps**: Disabled

---

## Tileset Creation

### Ground Tiles (16x16 each)
```
[หญ้า 1][หญ้า 2][หญ้า 3][หญ้า 4]
[ดิน 1][ดิน 2][ดิน 3][ดิน 4]
[หิน 1][หิน 2][พื้นวัด][พื้นบ้าน]
[น้ำ 1][น้ำ 2][น้ำ 3][น้ำ 4]
```

### Autotiling
- ใช้ Godot's Terrain system
- สร้าง transitions ระหว่าง tiles

---

## สมุนไพร (Herbs)

### ชนิดสมุนไพร
1. **Mint (สะระแหน่)**: สีเขียว
2. **Ginger (ขิง)**: สีน้ำตาลอ่อน
3. **Turmeric (ขมิ้น)**: สีเหลืองทอง
4. **Garlic (กระเทียม)**: สีขาวครีม

### ตัวอย่าง Mint Sprite (8x8)
```
  ████      (ใบ)
██████████  
████████    
  ████      
  ████      (ก้าน)
  ████      
```

---

## วิญญาณ (Spirit)

### Design Concept
- โปร่งใส (alpha 0.5-0.7)
- รูปร่างคล้ายคน แต่เบลอ
- สีขาวหรือฟ้าอ่อน
- มี glow effect (optional)

### Animation Frames
```
Frame 1: ตำแหน่งล่าง
Frame 2: ตำแหน่งกลาง
Frame 3: ตำแหน่งบน
Frame 4: ตำแหน่งกลาง
(loop back to Frame 1)
```

---

## ผู้ป่วย (Patient)

### Pose
- นอนหรือนั่งป่วย
- สีผิวซีด (pale colors)
- อาจมีผ้าห่ม

### States
1. **Sick**: สีซีด
2. **Critical**: สีแดง
3. **Healed**: สีปกติ/เขียว
4. **Dead**: สีเทา/ดำ

---

## อาคาร

### บ้าน (House)
- 32x32 pixels ขึ้นไป
- หลังคา + ผนัง + ประตู
- สีน้ำตาล/ไม้

### วัด (Temple)
- 48x48 pixels ขึ้นไป
- หลังคาแหลม (Thai style)
- สีทอง/แดง/เหลือง
- รายละเอียดมากกว่าบ้าน

---

## Effects

### น้ำเสีย (Dirty Water)
- สีเขียวมะกอก/น้ำตาล
- Semi-transparent
- Animated (optional)

### Particle Effects
- ดวงไฟ (วัด)
- เม็ดฝน
- หมอก
- ประกาย (เก็บสมุนไพร)

---

## Quick Start Templates

หากไม่มีเวลาทำ pixel art เอง สามารถใช้:

### Free Assets
1. **itch.io** - https://itch.io/game-assets/free/tag-pixel-art
2. **OpenGameArt** - https://opengameart.org/
3. **Kenney Assets** - https://www.kenney.nl/assets

### Search Keywords
- "top-down pixel art"
- "rpg character sprite"
- "16x16 tileset"
- "horror pixel art"

---

## Testing Sprites in Godot

1. Import sprite → Check filter is "Nearest"
2. Create AnimatedSprite2D
3. Create SpriteFrames resource
4. Add animations
5. Set FPS (frames per second)
6. Test in game

---

## Tips สำหรับมือใหม่

1. **เริ่มจากง่าย**: ทำ basic shapes ก่อน
2. **ใช้ Grid**: ทำให้ pixels เรียงตรง
3. **จำกัดสี**: ใช้ 4-8 สีต่อ sprite
4. **Outline**: ใช้สีดำหรือเข้มรอบ sprite
5. **Reference**: ดู pixel art อื่นๆ เป็นแบบอย่าง
6. **Practice**: ยิ่งทำยิ่งเก่ง!

---

## แหล่งเรียนรู้เพิ่มเติม

1. **YouTube**:
   - "Pixel Art Tutorial for Beginners"
   - "How to make Top-Down RPG sprites"
   
2. **Websites**:
   - https://lospec.com/ (Color palettes)
   - https://www.pixilart.com/ (Online editor)
   
3. **Community**:
   - r/PixelArt (Reddit)
   - Pixel Art Discord servers

---

## สรุป

จำไว้ว่า Pixel Art ไม่จำเป็นต้องสมบูรณ์แบบ! 
สำคัญที่สุดคือ gameplay และ atmosphere ของเกม
แม้ sprites จะง่ายๆ ก็สามารถสร้างเกมที่สนุกได้!

Good luck! 🎨
