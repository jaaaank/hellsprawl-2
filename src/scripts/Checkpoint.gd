extends Area2D

onready var current_scene_path = get_tree().get_current_scene().get_name()
onready var Sound: AudioStreamPlayer2D = $Sound
onready var AnimP: AnimationPlayer = $AnimP

func _on_Checkpoint_body_entered(body):
	GameData.checkpoint = current_scene_path
