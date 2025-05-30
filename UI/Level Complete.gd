extends Control
@onready var star1 = $"PanelContainer/MarginContainer/VBoxContainer/Stars/Container/1Star"
@onready var star2 = $"PanelContainer/MarginContainer/VBoxContainer/Stars/Container2/2Star"
@onready var star3 = $"PanelContainer/MarginContainer/VBoxContainer/Stars/Container3/3Star"

var fullstar  = preload("res://UI/StarFull.png")
var emptystar = preload("res://UI/StarEmpty.png")

var CurrLevel: int = 0
var times = []

func setLevelTimes(time1 : float,time2 : float,time3 : float):
	times.append(time1)
	times.append(time2)
	times.append(time3)

func LevelWon(timeTaken: float, CurrLevel: int):
	var starCount = 0
	get_tree().paused = true
	for s : TextureRect in [star3, star2, star1]:
		var timeForStar = times.pop_front()
		if timeForStar >= timeTaken:
			s.texture = fullstar
			starCount+=1
		else:
			s.texture = emptystar
		s.pivot_offset = s.texture.get_size() / 2
		var tween = create_tween()
		tween.tween_property(s, "scale", Vector2(0,0), 0) # Why the fuck can i not just set fucking scale, what is this bullshit.
	
	if starCount > GameState.get_stars(CurrLevel):
		GameState.update_progress(CurrLevel, starCount)
	
	for s in [star1, star2, star3]:
		var tween = create_tween()
		tween.tween_property(s, "scale", Vector2(1,1), 0.3).set_trans(Tween.TRANS_ELASTIC)
		await tween.finished

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/Main Menu.tscn")

func _on_continue_pressed():
	get_tree().paused = false
