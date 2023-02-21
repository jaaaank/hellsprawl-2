tool
extends Button


export(String, FILE) var next_scene_path: = ""
	
func _get_configuration_warning() -> String:
	return "next_scene_path must be set dumbfuck" if next_scene_path == "" else ""
	


func _on_ChangeSceneButton_button_up():
	get_tree().change_scene(next_scene_path)
