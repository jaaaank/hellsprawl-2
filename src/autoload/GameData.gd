extends Node

signal heath_changed
signal sword_unlocked
signal lance_unlocked
signal hammer_unlocked

var playerPos: Vector2 = Vector2.ZERO setget set_pos
var souls: int = 0 setget set_souls
var secrets: int = 0 setget set_secrets
var dashUnlocked: bool = false setget set_dash
var swordUnlocked: bool = false setget set_sword
var lanceUnlocked: bool = false setget set_lance
var hammerUnlocked: bool = false setget set_hammer
export var playerHealth: int = 5 setget set_health
var maxHealth: int = 5 setget set_max_health

func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().reload_current_scene()

func set_pos(value: Vector2) -> void:
	playerPos = value

func set_secrets(value: int) -> void:
	secrets = value
	
func set_souls(value: int) -> void:
	souls = value

func set_dash(value: bool) -> void:
	dashUnlocked = value

func set_sword(value: bool) -> void:
	swordUnlocked = value
	emit_signal("sword_unlocked")
	emit_signal("weapon_changed")

func set_lance(value: bool) -> void:
	lanceUnlocked = value
	emit_signal("lance_unlocked")

func set_hammer(value: bool) -> void:
	hammerUnlocked = value
	emit_signal("hammer_unlocked")
	
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



	#FOR MESSAGING ONLY
var currentWeapon: int = 0 setget set_current_weapon
signal weapon_changed

func set_current_weapon(value: int) -> void:
	currentWeapon = value
	emit_signal("weapon_changed")
