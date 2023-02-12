extends Control

export(String, FILE) var next_scene_path: = ""
onready var Animp:= $AnimationPlayer
onready var Sound:= $OpeningSound


func _ready():
	yield(get_tree().create_timer(.5), "timeout")
	Sound.play()
	yield(get_tree().create_timer(1), "timeout")
	Animp.play("fade")
	yield(Animp,"animation_finished")
	get_tree().change_scene(next_scene_path)


