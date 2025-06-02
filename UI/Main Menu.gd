extends Control

@onready var cont = $MarginContainer/VBoxContainer/Continue
@onready var level_select = $"MarginContainer/VBoxContainer/Level Select"
@onready var credits = $MarginContainer/VBoxContainer/Credits

func _ready():
	AudioManager.loadMenuMusic()
	cont.connect("pressed", _on_continue_pressed)
	level_select.connect("pressed", _on_level_select_pressed)
	credits.connect("pressed", _on_credits_pressed)
	#Find furthest level.

func _on_continue_pressed():
	if FileAccess.file_exists("res://Levels/Level {0}.tscn".format([GameState.get_current_level()])):
		get_tree().change_scene_to_file("res://Levels/Level {0}.tscn".format([GameState.get_current_level()]))
	else:
		get_tree().change_scene_to_file("res://Levels/Level End.tscn")

func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://UI/Level Selection.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://UI/Credits.tscn")
