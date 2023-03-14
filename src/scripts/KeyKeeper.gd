extends Enemy

onready var AnimP: = $AnimationPlayer
onready var sprite: = $Sprite
var canAttack: = false
var attkNum: = 0
var phase2: = false


func _ready():
	speed.x= 10.0
	health = 30
	_velocity.x = -speed.x + 100.0
	attkCooldown()


func _physics_process(delta: float)-> void:
	if _velocity.x< 0:
		sprite.flip_h = true
	elif _velocity.x> 0:
		sprite.flip_h = false

func attack():
	attkNum=(randi() % 7)
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
	attkCooldown()
	
func attkCooldown():
	canAttack = false
	yield (get_tree().create_timer(2.5), "timeout")
	canAttack = true
	attack()

func attk1():
	print("attk1")
	
func attk2():
	print("attk2")
	
func attk3():
	print("attk3")
	
func attk4():
	print("attk4")
	
func attk5():
	print("attk5")
	
func attk6():
	print("attk6")
	
func attk7():
	print("attk7")
