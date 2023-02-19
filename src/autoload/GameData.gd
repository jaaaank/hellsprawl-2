extends Node

signal heath_changed

export var playerPos: Vector2 = Vector2.ZERO setget set_pos
var secrets: int = 0 setget set_secrets
var dashUnlocked: bool = false setget set_dash
var lanceUnlocked: bool = false setget set_lance
var hammerUnlocked: bool = false setget set_hammer
export var playerHealth: int = 5 setget set_health
var maxHealth: int = 5 setget set_max_health


func set_pos(value: Vector2) -> void:
	playerPos = value

func set_secrets(value: int) -> void:
	secrets = value

func set_dash(value: bool) -> void:
	dashUnlocked = value

func set_lance(value: bool) -> void:
	lanceUnlocked = value

func set_hammer(value: bool) -> void:
	hammerUnlocked = value
	
func set_max_health(value: int) -> void:
	maxHealth = value
	emit_signal("heath_changed")

func set_health(value: int) -> void:
	playerHealth = value
	if playerHealth>maxHealth:
		playerHealth = maxHealth
	emit_signal("heath_changed")
	
	
		#NEED TO SAVE:
			#PLAYER POSITION
			#DASH UNLOCK STATE
			#NUMBER OF SECRETS
			#DEAD BOSSES
			#WEAPONS UNLOCKED
			#PLAYER MAX HEALTH
