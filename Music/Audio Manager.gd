extends Node2D
@onready var main_menu_music = $"Main Menu Music"
@onready var level_music = $"Level Music"
@onready var level_music_2 = $"Level Music 2"
@onready var speed = $Speed

var speedingUp : bool = false
var streamerActive: int = 1

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
	if not main_menu_music.playing:
		SwapFade(level_music, main_menu_music)
		speed.stop()

func loadLevelMusic():
	if not level_music.playing:
		SwapFade(main_menu_music, level_music)
		speed.stop()

func SwapFade(streamerOut : AudioStreamPlayer, streamerIn : AudioStreamPlayer):
	streamerIn.play()
	streamerIn.volume_db = -30
	var tween = create_tween()
	tween.tween_property(streamerOut, "volume_db", -30, 2)
	tween.set_parallel()
	tween.tween_property(streamerIn, "volume_db", 0, 2)
	await tween.finished
	streamerOut.stop()
