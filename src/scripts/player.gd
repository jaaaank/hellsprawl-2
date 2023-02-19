extends Actor

export (float, 0, 1.0) var acceleration = 0.25

onready var sprite: Sprite = $PlayerSprite
onready var AnimP:= $AnimationPlayer
onready var hitDetector := $HitDetector

onready var HeartBeat:= $SFX/HeartBeat
onready var HurtSound:= $SFX/Hurt
onready var DeathSound:= $SFX/Dead
onready var DashSound:= $SFX/Dash
onready var SwordSound:= $SFX/SwordAttack
onready var LanceSound:= $SFX/LanceAttack
onready var HammerSound:= $SFX/HammerAttack
# 0 = none, 1 = Bloodied Shortsword, 2 = Unholy Lance, 3 = Bloodstone Hammer
onready var currentWeapon: int = 0

var attacking: bool = false
var canJump: bool = true
var jumpPressed: bool = false
var iFrames: bool = false

var canAttack: bool = false
var swordUnlocked: bool = false
var lanceUnlocked: bool = false
var hammerUnlocked: bool = false

var canDoubleJump: bool = false
var canDash: bool = true
var canWallJump: bool = false


func _ready():
	GameData.connect("sword_unlocked", self, "swordUnlock")
	weaponCheck()
	health = GameData.playerHealth
	if swordUnlocked:
		canAttack = true

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
	if attacking:
		_velocity.x = _velocity.x / 10

func _input(event):
	print(GameData.playerHealth)
	if Input.is_action_just_pressed("attack") and canAttack:
		attack()
	if Input.is_action_just_pressed("weap1") and swordUnlocked:
		currentWeapon = 1
		GameData.currentWeapon = 1
	if Input.is_action_just_pressed("weap2") and lanceUnlocked:
		currentWeapon = 2
		GameData.currentWeapon = 2
	if Input.is_action_just_pressed("weap3") and hammerUnlocked:
		currentWeapon = 3
		GameData.currentWeapon = 3
		
	if Input.is_action_just_pressed("nextweap"):
		currentWeapon += 1
		GameData.currentWeapon += 1
		weaponCheck()
	if Input.is_action_just_pressed("prevweap"):
		currentWeapon -= 1
		GameData.currentWeapon -= 1
		weaponCheck()
	
	if Input.is_action_just_pressed("dash") and canDash and GameData.dashUnlocked:
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
		GameData.currentWeapon = 0
	if currentWeapon <1 and swordUnlocked:
		currentWeapon = 1
		GameData.currentWeapon = 1
	if currentWeapon >1 and!lanceUnlocked:
		currentWeapon = 1
		GameData.currentWeapon = 1
	if currentWeapon >2 and!hammerUnlocked:
		currentWeapon = 2
		GameData.currentWeapon = 2
	if currentWeapon >3:
		currentWeapon = 3
		GameData.currentWeapon = 3
		
	
func coyoteTime():
	yield(get_tree().create_timer(.1), "timeout")
	canJump = false
	pass

func rememberJumpTime():
	yield(get_tree().create_timer(.1),"timeout")
	jumpPressed = false
	pass
	
func swordAttack():
	attacking = true
	SwordSound.play()
	AnimP.play("attkS")
	yield(AnimP, "animation_finished")
	attacking = false
	
func lanceAttack():
	attacking = true
	LanceSound.play()
	AnimP.play("attkL")
	yield(AnimP, "animation_finished")
	attacking = false
	
func hammerAttack():
	attacking = true
	HammerSound.play()
	AnimP.play("attkH")
	yield(AnimP, "animation_finished")
	attacking = false

func dashCooldown():
	canDash = false
	yield(get_tree().create_timer(1), "timeout")
	canDash = true

func _on_HitDetector_body_entered(body):
	if not iFrames:
		print("hurt")
		health -= 1
		healthPush()
		hitDetector.set_collision_mask_bit(2, false)
		set_collision_mask_bit(2, false)
		iFrames = true
		if health == 1:
			HeartBeat.play()
		yield(get_tree().create_timer(1.5), "timeout")
		iFrames = false
		hitDetector.set_collision_mask_bit(2, true)
		set_collision_mask_bit(2, true)
		return
	else:
		return
	
func healthPush():
	if health>GameData.maxHealth:
		health = GameData.maxHealth
	GameData.playerHealth = health
	print("health pushed")

	
func healthPull():
	health = GameData.playerHealth
	print("health pulled")
	if health>GameData.maxHealth:
		health = GameData.maxHealth
	
func checkHealth():
	if health > GameData.maxHealth:
		health = GameData.maxHealth
	else:
		pass

func _on_HitDetector_area_entered(area):
	if area.is_in_group("healthPickup"):
		GameData.playerHealth += 3
		health += 3
		HeartBeat.playing = false
		checkHealth()
		healthPush()
	elif area.is_in_group("maxHealthPickup"):
		GameData.maxHealth += 1
		health += 10
		HeartBeat.playing = false
		checkHealth()
		healthPush()
	else:
		pass
		
func swordUnlock():
	print("waghasf")
	swordUnlocked = true
	canAttack = true
	weaponCheck()
