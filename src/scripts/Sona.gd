extends Area2D


onready var AnimP:= $AnimationPlayer

func _on_Sona_area_entered(area):
	print("gay")
	AnimP.play("Fishc")
	monitoring = false



func tradeSouls():
	if GameData.souls == 0:
		print("You don't have any souls")
	else:
		GameData.secrets += GameData.souls
		GameData.souls = 0
		print("New secrets unlocked, go to secrets in the main menu to check them out!")
