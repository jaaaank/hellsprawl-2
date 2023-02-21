extends Area2D


onready var AnimP:= $AnimationPlayer

func _on_Sona_area_entered(area):
	print("gay")
	AnimP.play("Fishc")
	monitoring = false
