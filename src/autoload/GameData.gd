extends Node

var dashUnlocked: bool = false setget set_dash
var secrets: int = 0 setget set_secrets

func set_secrets(value: int) -> void:
	secrets = value

func set_dash(value: bool) -> void:
	dashUnlocked = value

func _ready():
	pass # Replace with function body.
