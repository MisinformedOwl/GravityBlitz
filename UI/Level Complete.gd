extends Control
@onready var star1 = $"PanelContainer/MarginContainer/VBoxContainer/Stars/Container/1Star"
@onready var star2 = $"PanelContainer/MarginContainer/VBoxContainer/Stars/Container2/2Star"
@onready var star3 = $"PanelContainer/MarginContainer/VBoxContainer/Stars/Container3/3Star"

var CurrLevel: int = 0

func LevelWon():
	for s : TextureRect in [star1, star2, star3]:
		s.pivot_offset = s.texture.get_size() / 2
		var tween = create_tween()
		tween.tween_property(s, "scale", Vector2(0,0), 0) # Why the fuck can i not just set fucking scale, what is this bullshit.
		
	for s in [star1, star2, star3]:
		var tween = create_tween()
		tween.tween_property(s, "scale", Vector2(1,1), 1).set_trans(Tween.TRANS_ELASTIC)
		await tween.finished


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://UI/Main Menu.tscn")
