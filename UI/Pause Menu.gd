extends Control



func _on_resume_pressed():
	get_tree().paused = false
	visible = false

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://UI/Main Menu.tscn")
