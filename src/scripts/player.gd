extends Actor

export (float, 0, 1.0) var acceleration = 0.25

onready var sprite: Sprite = $PlayerSprite
onready var AnimP:= $AnimationPlayer

onready var SwordSound:= $SFX/SwordAttack
onready var WhipSound:= $SFX/WhipAttack
onready var LanceSound:= $SFX/LanceAttack
onready var HammerSound:= $SFX/HammerAttack
# 0 = none, 1 = Bloodied Shortsword, 2 = Horseman’s Whip, 3 =Unholy Lance, 4 = Blood Hammer
onready var currentWeapon: int = 0

var canJump: bool = true
var jumpPressed: bool = false

var swordUnlocked: bool = false
var whipUnlocked: bool = false
var lanceUnlocked: bool = false
var hammerUnlocked: bool = false

var canDoubleJump: bool = false
var canDash: bool = true
var canWallJump: bool = false


func _ready():
	pass

func _physics_process(delta):
	var jumpInterrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	move_and_slide(_velocity, FLOOR_NORMAL)
	
	if Input.is_action_just_pressed("dash"):
		if sprite.flip_h:
			AnimP.play("dashL")
			yield(AnimP, "animation_finished")
		else:
			AnimP.play("dashR")
			yield(AnimP, "animation_finished")
			
	if jumpInterrupted:
		_velocity.y = 0.0
	if Input.is_action_just_pressed("jump"):
		jumpPressed = true
		rememberJumpTime()
		if canJump:
			_velocity.y = -speed.y
			
	if is_on_floor():
		canJump = true
		if jumpPressed:
			_velocity.y = -speed.y
		
	
	if !is_on_floor():
		coyoteTime()
		_velocity.y += gravity * delta
	
	if Input.is_action_pressed("right"):
		_velocity.x = speed.x
	elif Input.is_action_pressed("left"):
		_velocity.x = -speed.x
	else:
		_velocity.x = 0
		
	if _velocity.x< 0:
		sprite.flip_h = true
	elif _velocity.x> 0:
		sprite.flip_h = false

func _input(event):
			#WEAPON CHECKS
	if Input.is_action_just_pressed("attack"):
		attack()
		print("attacked")
	if Input.is_action_just_pressed("weap1") and swordUnlocked:
		currentWeapon = 1
	if Input.is_action_just_pressed("weap2") and whipUnlocked:
		currentWeapon = 2
	if Input.is_action_just_pressed("weap3") and lanceUnlocked:
		currentWeapon = 3
	if Input.is_action_just_pressed("weap4") and hammerUnlocked:
		currentWeapon = 4
		
	if Input.is_action_just_pressed("nextweap"):
		currentWeapon += 1
		weaponCheck()
	if Input.is_action_just_pressed("prevweap"):
		currentWeapon -= 1
		weaponCheck()
	
		
			#ATTACKING STUFF
func attack():
	if currentWeapon == 0:
		pass
	elif currentWeapon == 1:
		swordAttack()
	elif currentWeapon == 2:
		whipAttack()
	elif currentWeapon == 3:
		lanceAttack()
	elif currentWeapon == 4:
		hammerAttack()
		
func weaponCheck():
	if currentWeapon <1 and swordUnlocked:
		currentWeapon = 1
	if currentWeapon >1 and!whipUnlocked:
		currentWeapon = 1
	if currentWeapon >2 and!lanceUnlocked:
		currentWeapon = 2
	if currentWeapon >3 and!hammerUnlocked:
		currentWeapon = 3
	if currentWeapon >4:
		currentWeapon = 4
		
	
func coyoteTime():
	yield(get_tree().create_timer(.1), "timeout")
	canJump = false
	pass

func rememberJumpTime():
	yield(get_tree().create_timer(.1),"timeout")
	jumpPressed = false
	pass
	
func swordAttack():
	SwordSound.play()
	AnimP.play("attkS")
	
func whipAttack():
	WhipSound.play()
	AnimP.play("attkW")
	
func lanceAttack():
	LanceSound.play()
	AnimP.play("attkL")
	
func hammerAttack():
	HammerSound.play()
	AnimP.play("attkH")
