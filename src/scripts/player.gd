extends Actor

onready var sprite: Sprite = $PlayerSprite
onready var AnimP:= $AnimationPlayer

onready var LanceSound:= $SFX/LanceAttack
onready var SwordSound:= $SFX/SwordAttack
onready var HammerSound:= $SFX/HammerAttack
onready var WhipSound:= $SFX/WhipAttack
# 0 = none, 1 = Bloodied Shortsword, 2 = Unholy Lance, 3 = Horseman’s Whip, 4 = Blood Hammer
onready var currentWeapon: int = 0

var swordUnlocked: bool = false
var lanceUnlocked: bool = false
var whipUnlocked: bool = false
var hammerUnlocked: bool = false

var canDoubleJump: bool = false
var canDash: bool = false
var canWallJump: bool = false


func _ready():
	pass

func _physics_process(_delta: float) -> void:
	var dir: = get_direction() 
	
	if Input.is_action_just_pressed("weap1") and swordUnlocked:
		currentWeapon = 1
	if Input.is_action_just_pressed("weap2") and lanceUnlocked:
		currentWeapon = 2
	if Input.is_action_just_pressed("weap3") and whipUnlocked:
		currentWeapon = 3
	if Input.is_action_just_pressed("weap4") and hammerUnlocked:
		currentWeapon = 4
		
	if Input.is_action_just_pressed("nextweap"):
		currentWeapon += 1
		weaponCheck()
	if Input.is_action_just_pressed("prevweap"):
		currentWeapon -= 1
		weaponCheck()

	
	if _velocity.x< 0:
		sprite.flip_h = true
	elif _velocity.x> 0:
		sprite.flip_h = false
		
		


func attack():
	if currentWeapon == 0:
		pass
	elif currentWeapon == 1:
		SwordSound.play()
	elif currentWeapon == 2:
		LanceSound.play()
	elif currentWeapon == 3:
		WhipSound.play()
	elif currentWeapon == 4:
		HammerSound.play()
		
func get_direction() -> Vector2:
	return Vector2 (
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0)

func weaponCheck():
	if currentWeapon <1 and swordUnlocked:
		currentWeapon = 1
	if currentWeapon >1 and!lanceUnlocked:
		currentWeapon = 1
	if currentWeapon >2 and!whipUnlocked:
		currentWeapon = 2
	if currentWeapon >3 and!hammerUnlocked:
		currentWeapon = 3
	if currentWeapon >4:
		currentWeapon = 4
