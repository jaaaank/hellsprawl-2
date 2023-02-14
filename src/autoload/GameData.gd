extends Node

signal healed

export var playerPos: Vector2 = Vector2.ZERO setget set_pos
var secrets: int = 0 setget set_secrets
var dashUnlocked: bool = false setget set_dash
export var playerHealth: int = 10 setget set_health


func set_pos(value: Vector2) -> void:
	playerPos = value

func set_secrets(value: int) -> void:
	secrets = value

func set_dash(value: bool) -> void:
	dashUnlocked = value

func set_health(value: int) -> void:
	playerHealth = value
	if playerHealth>10:
		playerHealth = 10
	
	
