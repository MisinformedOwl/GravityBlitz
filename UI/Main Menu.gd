extends Control

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://Levels/Level 1.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://UI/Credits.tscn")

func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://UI/Level Selection.tscn")
