extends Node2D
@onready var main_menu_music = $"Main Menu Music"
@onready var level_music = $"Level Music"
@onready var speed = $Speed

var speedingUp : bool = false

func playerSpeedUp():
	if not speedingUp:
		speed.play()
		var tween = create_tween()
		tween.tween_property(speed, "volume_db", 0, 1.5)
		speedingUp = true

func playerStopped():
	speed.stop()
	speed.volume_db = -30
	speedingUp = false

func loadMenuMusic():
	main_menu_music.play()
	level_music.stop()
	speed.stop()

func loadLevelMusic():
	main_menu_music.stop()
	level_music.play()
	speed.stop()
