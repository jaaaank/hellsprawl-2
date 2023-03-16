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
var dashing: bool = false

var canAttack: bool = false
var swordUnlocked: bool = false
var lanceUnlocked: bool = false
var hammerUnlocked: bool = false
var canDash: bool = true


func _ready():
	health = GameData.playerHealth
	if health == 1:
		HeartBeat.play()
	currentWeapon = GameData.currentWeapon
	GameData.connect("sword_unlocked", self, "swordUnlock")
	GameData.connect("lance_unlocked", self, "lanceUnlock")
	GameData.connect("hammer_unlocked", self, "hammerUnlock")
	weaponCheck()
	if GameData.swordUnlocked:
		swordUnlock()
		canAttack = true
	if GameData.lanceUnlocked:
		lanceUnlock()
	if GameData.hammerUnlocked:
		hammerUnlock()

func _physics_process(delta):
	if iFrames:
		_velocity.x *= .4
		
	GameData.playerPosition = position

	move_and_slide(_velocity, FLOOR_NORMAL)

	var jumpInterrupted: = (Input.is_action_just_released("jump") or is_on_ceiling()) and _velocity.y < 0.0
	
	if jumpInterrupted:
		_velocity.y = 0.0
	if Input.is_action_just_pressed("jump"):
		jumpPressed = true
		rememberJumpTime()
		if canJump:
			_velocity.y = -speed.y
			
	if is_on_floor() and !attacking and !dashing:
		canJump = true
		if jumpPressed:
			_velocity.y = -speed.y
		if _velocity.x!=0:
			AnimP.play("walk")
		else:
			AnimP.play("idle")
	if !is_on_floor() and !attacking and !dashing:
		coyoteTime()
		_velocity.y += gravity * delta
		if _velocity.y>0:
			AnimP.play("fall")
		else:
			AnimP.play("jump")
	
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
	if Input.is_action_just_pressed("attack") and canAttack:
		attack()
		_velocity.y = 200
	if Input.is_action_just_pressed("weap1") and GameData.swordUnlocked:
		currentWeapon = 1
		GameData.currentWeapon = 1
	if Input.is_action_just_pressed("weap2") and GameData.lanceUnlocked:
		currentWeapon = 2
		GameData.currentWeapon = 2
	if Input.is_action_just_pressed("weap3") and GameData.hammerUnlocked:
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
		dashing = true
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
		dashing = false
		
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
	if currentWeapon > 0 and !GameData.swordUnlocked:
		currentWeapon = 0
		GameData.currentWeapon = 0
	if currentWeapon <1 and GameData.swordUnlocked:
		currentWeapon = 1
		GameData.currentWeapon = 1
	if currentWeapon >1 and!GameData.lanceUnlocked:
		currentWeapon = 1
		GameData.currentWeapon = 1
	if currentWeapon >2 and!GameData.hammerUnlocked:
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
	canJump = false
	SwordSound.play()
	AnimP.play("attkS")
	yield(AnimP, "animation_finished")
	attacking = false
	canJump = true
	
func lanceAttack():
	attacking = true
	canJump = false
	LanceSound.play()
	AnimP.play("attkL")
	yield(AnimP, "animation_finished")
	attacking = false
	canJump = true
	
func hammerAttack():
	attacking = true
	canJump = false
	HammerSound.play()
	AnimP.play("attkH")
	yield(AnimP, "animation_finished")
	attacking = false
	canJump = true

func dashCooldown():
	canDash = false
	yield(get_tree().create_timer(1), "timeout")
	canDash = true

func _on_HitDetector_body_entered(body):
	damage()
	
func healthPush():
	if health>GameData.maxHealth:
		health = GameData.maxHealth
	GameData.playerHealth = health

	
func healthPull():
	health = GameData.playerHealth
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
	elif area.get_collision_layer_bit(5):
		damage()
	elif area.is_in_group("bouncePad"):
		if Input.is_action_pressed("jump"):
			_velocity.y = -speed.y*1.3
		else:
			_velocity.y = -speed.y*1.2
	elif area.get_collision_layer_bit(2):
		damage()
	else:
		pass
		
func swordUnlock():
	swordUnlocked = true
	canAttack = true
	weaponCheck()

func lanceUnlock():
	lanceUnlocked = true
	canAttack = true
	weaponCheck()

func hammerUnlock():
	hammerUnlocked = true
	canAttack = true
	weaponCheck()

func damage():
	if not iFrames:
		health -= 1
		healthPush()
		hitDetector.set_collision_mask_bit(2, false)
		set_collision_mask_bit(2, false)
		hitDetector.set_collision_mask_bit(5, false)
		iFrames = true
		if health == 1:
			HeartBeat.play()
		yield(get_tree().create_timer(1.5), "timeout")
		iFrames = false
		hitDetector.set_collision_mask_bit(2, true)
		set_collision_mask_bit(2, true)
		hitDetector.set_collision_mask_bit(5, true)
		return
	else:
		return

