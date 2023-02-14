extends Area2D



func _ready():
	if GameData.dashUnlocked:
		queue_free()

func _on_DashUnlock_body_entered(body):
	
	GameData.dashUnlocked = true
	queue_free()
