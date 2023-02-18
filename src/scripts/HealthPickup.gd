extends Area2D





func _on_HealthPickup_body_entered(body):
	GameData.playerHealth += 3
	queue_free()
