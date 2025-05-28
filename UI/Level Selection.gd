extends Control

@onready var grid = $PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/GridContainer


var buttonStyle = preload("res://UI/ButtonFull.tres")

func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/Main Menu.tscn")

func _ready():
	for x in range(1,80):
		var b : Button = Button.new()
		b.text = str(x)
		b.add_theme_font_size_override("font_size", 60)  # Set font size
		b.size_flags_horizontal = b.SIZE_EXPAND
		
		var style = buttonStyle
		b.add_theme_stylebox_override("normal", style)
		grid.add_child(b)
		b.pressed.connect(_levelSelected.bind(b))

func _levelSelected(button : Button):
	get_tree().change_scene_to_file("res://Levels/Level {0}.tscn".format([button.text]))
