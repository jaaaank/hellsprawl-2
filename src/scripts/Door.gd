extends KinematicBody2D

onready var button:= $Button
onready var animp:= $AnimationPlayer
var locked:= true
var open:= false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Sensor_body_entered(body):
	if !locked:
		animp.play("open")

func _on_Sensor_body_exited(body):
	if !locked:
		animp.play("close")


func _on_Button_body_entered(body):
	locked = false
