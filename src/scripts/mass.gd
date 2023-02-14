extends Enemy

onready var AnimP: = $AnimationPlayer
onready var sprite: Sprite = $Sprite

func _ready() -> void:
	speed.x= 60.0
	AnimP.play("walk")
	health = 1
	_velocity.x = -speed.x + 200.0
	
func _physics_process(delta: float) -> void:
	if _velocity.x< 0:
		sprite.flip_h = true
	elif _velocity.x> 0:
		sprite.flip_h = false
		


func _on_Hitbox_area_entered(area):
	health -=1
	if health <= 0:
		queue_free()

