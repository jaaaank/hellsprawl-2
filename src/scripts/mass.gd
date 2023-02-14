extends Enemy

onready var AnimP: = $AnimationPlayer
onready var sprite: Sprite = $Mass

func _ready() -> void:
	speed.x= 60.0
	AnimP.play("walk")
	health = 1
	set_physics_process(false)
	_velocity.x = -speed.x + 200.0
	
func _physics_process(delta: float) -> void:
	if _velocity.x< 0:
		sprite.flip_h = true
	elif _velocity.x> 0:
		sprite.flip_h = false
		
