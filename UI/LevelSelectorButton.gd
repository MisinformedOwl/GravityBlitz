extends PanelContainer
@onready var button = $VBoxContainer/Button
@onready var label = $VBoxContainer/HBoxContainer/Label

func setup(num: int, stars: int, enabled:bool):
	label.text = str(stars)
	button.disabled = enabled
	button.text = str(num)
