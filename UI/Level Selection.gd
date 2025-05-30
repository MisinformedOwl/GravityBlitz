extends Control

@onready var grid = $PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/GridContainer

var buttonStyle = preload("res://UI/ButtonFull.tres")
var buttonObj = preload("res://UI/LevelSelectionButton.tscn")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/Main Menu.tscn")

func _ready():
	for x in range(1,81):
		var disable = false
		var b = buttonObj.instantiate()
		if x >= GameState.get_current_level():
			disable = true
		grid.add_child(b)
		b.setup(x, GameState.get_stars(x), disable)
		
		var style = buttonStyle
		b.button.pressed.connect(_levelSelected.bind(b.button))

func _levelSelected(button : Button):
	get_tree().change_scene_to_file("res://Levels/Level {0}.tscn".format([button.text]))
