extends Node

var dashUnlocked: bool = false setget set_dash
var secrets: int = 0 setget set_secrets
export var playerPos: Vector2 = Vector2.ZERO setget set_pos

func set_pos(value: Vector2) -> void:
	playerPos = value

func set_secrets(value: int) -> void:
	secrets = value

func set_dash(value: bool) -> void:
	dashUnlocked = value

func _ready():
	pass # Replace with function body.
