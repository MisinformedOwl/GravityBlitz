extends Node2D
@onready var main_menu_music = $"Main Menu Music"
@onready var level_music = $"Level Music"
@onready var level_music_2 = $"Level Music 2"
@onready var speed = $Speed
@onready var timer = $SwitchTimer
@onready var victory = $Victory

var music = [preload("res://Music/Track1.mp3"), preload("res://Music/Track2.mp3"), preload("res://Music/Track3.mp3")]
var trackNumber = 1
var levelNumberTracker = 0

var currentStreamer : AudioStreamPlayer

var speedingUp : bool = false

func _ready():
	currentStreamer = main_menu_music

func tickLevelCount():
	levelNumberTracker +=1
	if levelNumberTracker > 3 or currentStreamer.is_in_group("Menu"):
		loadLevelMusic()
		levelNumberTracker = 0

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
	timer.stop()
	if not main_menu_music.playing:
		SwapFade(currentStreamer, main_menu_music)
		speed.stop()

func loadLevelMusic():
	if level_music.playing:
		SwapFade(currentStreamer, level_music_2)
	else:
		SwapFade(currentStreamer, level_music)
	speed.stop()

func SwapFade(streamerOut : AudioStreamPlayer, streamerIn : AudioStreamPlayer):
	timer.start()
	streamerIn.play()
	streamerIn.volume_db = -30
	var tween = create_tween()
	tween.tween_property(streamerOut, "volume_db", -30, 2)
	tween.set_parallel()
	tween.tween_property(streamerIn, "volume_db", 0, 2)
	await tween.finished
	if streamerOut.is_in_group("LevelMusic"):
		nextTrack(streamerOut)
		pass
	streamerOut.stop()
	currentStreamer = streamerIn

func nextTrack(streamer: AudioStreamPlayer):
	trackNumber+=1
	if trackNumber >= len(music):
		trackNumber = 0
	streamer.stream = music[trackNumber]

func playVictory():
	victory.play()

func _on_switch_timer_timeout():
	loadLevelMusic()

func dimMusic():
	AudioServer.set_bus_volume_db(2,-30)


func undimMusic():
	AudioServer.set_bus_volume_db(2,-15)
