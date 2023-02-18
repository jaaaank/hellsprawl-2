extends Actor

export (float, 0, 1.0) var acceleration = 0.25

onready var sprite: Sprite = $PlayerSprite
onready var AnimP:= $AnimationPlayer

onready var HurtSound:= $SFX/Hurt
onready var DeathSound:= $SFX/Dead
onready var DashSound:= $SFX/Dash
onready var SwordSound:= $SFX/SwordAttack
onready var LanceSound:= $SFX/LanceAttack
onready var HammerSound:= $SFX/HammerAttack
# 0 = none, 1 = Bloodied Shortsword, 2 = Horseman’s Whip, 3 =Unholy Lance, 4 = Blood Hammer
onready var currentWeapon: int = 0

var canJump: bool = true
var jumpPressed: bool = false

var canAttack: bool = true
var swordUnlocked: bool = true
var lanceUnlocked: bool = true
var hammerUnlocked: bool = true

var canDoubleJump: bool = false
var canDash: bool = true
var canWallJump: bool = false


func _ready():
	weaponCheck()

func _physics_process(delta):
	var jumpInterrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	move_and_slide(_velocity, FLOOR_NORMAL)
	GameData.playerPos = position
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
	
	if Input.is_action_pressed("right") and Input.is_action_pressed("left"):
		_velocity.x = 0
	elif Input.is_action_pressed("right"):
		if currentWeapon == 3:
			_velocity.x = speed.x - 200
		else:
			_velocity.x = speed.x
	elif Input.is_action_pressed("left"):
		if currentWeapon == 3:
			_velocity.x = -speed.x + 200
		else:
			_velocity.x = -speed.x
	else:
		_velocity.x = 0
		
	if _velocity.x< 0:
		sprite.flip_h = true
	elif _velocity.x> 0:
		sprite.flip_h = false

func _input(event):
	print(health)
	if Input.is_action_just_pressed("attack") and canAttack:
		attack()
		print("attacked")
	if Input.is_action_just_pressed("weap1") and swordUnlocked:
		currentWeapon = 1
	if Input.is_action_just_pressed("weap2") and lanceUnlocked:
		currentWeapon = 2
	if Input.is_action_just_pressed("weap3") and hammerUnlocked:
		currentWeapon = 3
		
	if Input.is_action_just_pressed("nextweap"):
		currentWeapon += 1
		weaponCheck()
	if Input.is_action_just_pressed("prevweap"):
		currentWeapon -= 1
		weaponCheck()
	
	if Input.is_action_just_pressed("dash") and canDash:
		DashSound.play()
		canAttack = false
		if sprite.flip_h:
			AnimP.play("dashL")
			dashCooldown()
			yield(AnimP, "animation_finished")
			canAttack = true
		else:
			AnimP.play("dashR")
			dashCooldown()
			yield(AnimP, "animation_finished")
			canAttack = true
		
			#ATTACKING STUFF
func attack():
	if currentWeapon == 0:
		pass
	elif currentWeapon == 1:
		swordAttack()
	elif currentWeapon == 2:
		lanceAttack()
	elif currentWeapon == 3:
		hammerAttack()
		
func weaponCheck():
	if currentWeapon > 0 and !swordUnlocked:
		currentWeapon = 0
	if currentWeapon <1 and swordUnlocked:
		currentWeapon = 1
	if currentWeapon >1 and!lanceUnlocked:
		currentWeapon = 1
	if currentWeapon >2 and!hammerUnlocked:
		currentWeapon = 2
	if currentWeapon >3:
		currentWeapon = 3
		
	
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
	
func lanceAttack():
	LanceSound.play()
	AnimP.play("attkL")
	
func hammerAttack():
	HammerSound.play()
	AnimP.play("attkH")

func dashCooldown():
	canDash = false
	yield(get_tree().create_timer(1), "timeout")
	canDash = true

func _on_HitDetector_body_entered(body):
	print("hurt")
	health -= 1
	updateHealth()
	
func updateHealth():
	if health>GameData.maxHealth:
		health = GameData.maxHealth
	GameData.playerHealth = health
	print("health pushed")

	
func healthCheck():
	health = GameData.playerHealth
	print("health pulled")
	if health>GameData.maxHealth:
		health = GameData.maxHealth
	

	#this WILL NOT WORK if running under 30 fps
func _on_HitDetector_area_entered(area):
	yield(get_tree().create_timer(.03334), "timeout")
	healthCheck()
