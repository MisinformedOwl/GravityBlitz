extends Control



func _on_resume_pressed():
	AudioManager.undimMusic()
	get_tree().paused = false
	visible = false

func _on_main_menu_pressed():
	AudioManager.undimMusic()
	GameState.skip_intro = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/Main Menu.tscn")

func _on_button_pressed():
	AudioManager.undimMusic()
	get_tree().paused = false
	get_tree().reload_current_scene()
