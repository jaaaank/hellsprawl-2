tool
extends Area2D

export(String, FILE) var next_room_path: = ""
export var spawn: int = 1

func _ready():
	GameData.spawnNum = spawn

func _get_configuration_warning() -> String:
	return "next_room_path PORTAL must be set dumbfuck" if next_room_path == "" else ""
	

func _on_RoomTransition_body_entered(body):
	get_tree().change_scene(next_room_path)
