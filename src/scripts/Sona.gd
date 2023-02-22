extends Area2D

onready var buttons:= $CanvasLayer
onready var AnimP:= $AnimationPlayer
onready var TradeConf:RichTextLabel= $CanvasLayer/TradeConf
onready var NoSouls:RichTextLabel= $CanvasLayer/NoSouls
onready var GotSouls:RichTextLabel= $CanvasLayer/GotSouls


func _ready():
	TradeConf.visible = true
	if GameData.sonaHurt:
		AnimP.play("ded")
		monitoring = false

func _on_Sona_area_entered(area):
	AnimP.play("Fishc")
	GameData.sonaHurt = true
	yield(get_tree().create_timer(.5), "timeout")
	monitoring = false


func _on_YES_button_up():
	TradeConf.visible = false
	tradeSouls()
	yield(get_tree().create_timer(1.5), "timeout")
	buttons.visible = false
	TradeConf.visible = true
	NoSouls.visible = false
	GotSouls.visible = false

func tradeSouls():
	if GameData.souls == 0:
		NoSouls.visible = true
	else:
		GotSouls.visible = true
		GameData.secrets += GameData.souls
		GameData.souls = 0

func _on_NO_button_up():
	buttons.visible = false
