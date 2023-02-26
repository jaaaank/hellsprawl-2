extends Enemy

onready var AnimP:= $AnimationPlayer
onready var sprite:= $Sprite
onready var sensor:= $PlayerSensor
onready var lance:= $Lance
onready var disSensor:= $PlayerSensor/CollisionShape2D
var attacking = false

func _ready() -> void:
	speed.x= 60.0
	AnimP.play("walk")
	health = 3
	_velocity.x = -speed.x + 200.0
	
func _physics_process(delta: float) -> void:
	if _velocity.x< 0:
		sprite.flip_h = false
		sensor.scale.x = 1
		lance.scale.x = 1
	elif _velocity.x> 0:
		sprite.flip_h = true
		sensor.scale.x = -1
		lance.scale.x = -1
		


func _on_Hitbox_area_entered(area):
	health -=1
	_velocity.x *= -1
	if health <= 0:
		queue_free()


func _on_PlayerSensor_body_entered(body):
	if !attacking:
		attack()

func attack():
	attacking = true
	disSensor.disabled = true
	set_physics_process(false)
	AnimP.play("attack")
	yield(AnimP,"animation_finished")
	set_physics_process(true)
	AnimP.play("walk")
	disSensor.disabled = false
	_velocity.x *= -1
	attacking = false
