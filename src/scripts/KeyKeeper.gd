extends Enemy

onready var AnimP: = $AnimationPlayer
onready var sprite: = $Sprite
onready var sword: = $Sword
onready var spikes: = $"-spikes-"
var rng = RandomNumberGenerator.new()
var flipped: = false
var canAttack: = false
var attkNum: = 0
var phase2: = true


func _ready():
	speed.x= 10.0
	health = 30
	_velocity.x = -speed.x + 100.0
	attkCooldown()


func _physics_process(delta: float)-> void:
	if _velocity.x< 0:
		sprite.flip_h = true
		if not flipped:
			sword.scale.x *= -1
			spikes.scale.x *= -1
			flipped = true
	elif _velocity.x> 0:
		sprite.flip_h = false
		if flipped:
			sword.scale.x *= -1
			spikes.scale.x *= -1
			flipped = false

func attack():
	attkNum=(rng.randi_range(0, 7))
	if attkNum==0:
		print("didnt attack")
	elif attkNum==1:
		attk1()
	elif attkNum==2:
		attk2()
	elif attkNum==3:
		attk3()
	elif attkNum==4:
		attk4()
	elif attkNum==5:
		attk5()
	elif attkNum==6:
		attk6()
	elif attkNum==7:
		if phase2==true:
			attk7()
		else:
			attk6()
	
func attkCooldown():
	canAttack = false
	yield (get_tree().create_timer(2.5), "timeout")
	canAttack = true
	attack()

func attk1():
	set_physics_process(false)
	AnimP.play("attk1")
	print("attk1")
	yield(AnimP, "animation_finished")
	set_physics_process(true)
	attkCooldown()
	
func attk2():
	set_physics_process(false)
	print("attk2")
	AnimP.play("attk2")
	yield(AnimP, "animation_finished")
	set_physics_process(true)
	attkCooldown()
	
func attk3():
	set_physics_process(false)
	if !phase2:
		print("attk3")
		AnimP.play("attk3")
	else:
		AnimP.play("altattk3")
		print("altattk3")
	yield(AnimP, "animation_finished")
	set_physics_process(true)
	attkCooldown()
	
func attk4():
	print("attk4")
	attkCooldown()

	
func attk5():
	set_physics_process(false)
	print("attk5")

	set_physics_process(true)
	attkCooldown()
	
func attk6():
	set_physics_process(false)
	print("attk6")
	AnimP.play("attk6")
	yield(AnimP, "animation_finished")
	set_physics_process(true)
	attkCooldown()
	
func attk7():
	set_physics_process(false)
	print("attk7")

	set_physics_process(true)
	attkCooldown()


func _on_Hurtbox_area_entered(area):
	if area.get_collision_layer_bit(1):
		damage()

func damage():
	health -= 1
	print(health)
	if health <=0:
		queue_free()
