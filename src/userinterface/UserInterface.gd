extends Control

onready var vignette: CanvasLayer = $HealthVignette
onready var curWeap: Sprite = $AspectRatioContainer/CurrentWeapon
onready var heart6: Sprite = $HealthBar/Heart6
onready var heart7: Sprite = $HealthBar/Heart7
onready var heart8: Sprite = $HealthBar/Heart8
onready var heart9: Sprite = $HealthBar/Heart9
onready var heart10: Sprite = $HealthBar/Heart10
onready var AnimP:= $AnimationPlayer

func _ready():
	GameData.connect("heath_changed", self, "update_interface")
	GameData.connect("weapon_changed", self, "update_interface")
	update_interface()
	
func update_interface():
	checkMaxHearts()
	animateHearts()
	animateWeapIcons()
	
	
func animateHearts():
	if GameData.playerHealth == 10:
		AnimP.play("10hp")
		vignette.visible = false
		return
	elif GameData.playerHealth == 9:
		AnimP.play("9hp")
		vignette.visible = false
		return
	elif GameData.playerHealth == 8:
		AnimP.play("8hp")
		vignette.visible = false
		return
	elif GameData.playerHealth == 7:
		AnimP.play("7hp")
		vignette.visible = false
		return
	elif GameData.playerHealth == 6:
		AnimP.play("6hp")
		vignette.visible = false
		return
	elif GameData.playerHealth == 5:
		AnimP.play("5hp")
		vignette.visible = false
		return
	elif GameData.playerHealth == 4:
		AnimP.play("4hp")
		vignette.visible = false
		return
	elif GameData.playerHealth == 3:
		AnimP.play("3hp")
		vignette.visible = false
		return
	elif GameData.playerHealth == 2:
		AnimP.play("2hp")
		vignette.visible = false
		return
	elif GameData.playerHealth == 1:
		AnimP.play("1hp")
		vignette.visible = true
		return
	else:
		AnimP.play("0hp")

func checkMaxHearts():
	if GameData.maxHealth >9:
		heart6.visible = true
		heart7.visible = true
		heart8.visible = true
		heart9.visible = true
		heart10.visible = true
		animateHearts()
		return
	elif GameData.maxHealth >8:
		heart6.visible = true
		heart7.visible = true
		heart8.visible = true
		heart9.visible = true
		animateHearts()
		return
	elif GameData.maxHealth >7:
		heart6.visible = true
		heart7.visible = true
		heart8.visible = true
		animateHearts()
		return
	elif GameData.maxHealth >6:
		heart6.visible = true
		heart7.visible = true
		animateHearts()
		return
	elif GameData.maxHealth >5:
		heart6.visible = true
		animateHearts()
		return
	else:
		animateHearts()
		return

func animateWeapIcons():
	if GameData.currentWeapon == 0:
		curWeap.visible = false
	else:
		curWeap.visible = true
		if GameData.currentWeapon == 1:
			curWeap.frame = 0
		elif GameData.currentWeapon == 2:
			curWeap.frame = 1
		elif GameData.currentWeapon == 3:
			curWeap.frame = 2
		else:
			return
