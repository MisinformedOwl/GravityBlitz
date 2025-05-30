extends Node2D

var goalPointerLoader = preload("res://Mechanics and Assets/GoalPointer.tscn")

@onready var tile_map = $Floor
@onready var player = $Player
@onready var gravitation = $Gravitation
@onready var camera = $Camera2D
@onready var background = $Background
@onready var ui = $"UI Layer"
@onready var pause_menu = $"UI Layer/Pause Menu"
@onready var fade_transition = $"UI Layer/Fade transition"
@onready var CenterOfCanvas = $"UI Layer/CenterOfCanvas"
@onready var arrow_button = $"UI Layer/ButtonContainer/MarginContainer2/ArrowButton"
@onready var levelTitle = $"UI Layer/Fade transition/MarginContainer/Title"
@onready var completeMenu = $"UI Layer/Level Complete"

@export var LevelNum : int = 0
@export var LevelName : String = ""

@export var time1 : float = 0.0
@export var time2 : float = 0.0
@export var time3 : float = 0.0
var startTime

var goals = []
var gPointers = []
var playerDying : bool = false

signal goal_reached
signal playerDeath
signal updateChildren

func _ready():
	#Set the times of the level
	completeMenu.setLevelTimes(time1,time2,time3)
	
	#Holds player until the scene begins to fade in. Particularly a problem with the black hole tutorial...
	player.set_physics_process(false)
	
	#If the player has already seen the intro, skip it for brevity and time saving for the player.
	if GameState.skip_intro:
		fade_transition.visible = false
		player.set_physics_process(true)
		startTime = Time.get_ticks_msec()
	else:
		fade_transition.visible = true
		var titleTween = create_tween()
		titleTween.connect("finished", _on_loadin_timeout)
		levelTitle.text = "Level {0}\n\n{1}".format([LevelNum,LevelName])
		titleTween.tween_property(levelTitle, "modulate", Color(1,1,1,1), 2)
	
	#Position the node to the middle of the canvas for use in goal pointers.
	CenterOfCanvas.position = get_viewport_rect().size/2
	#Background hidden so i can actually see what im doing when designing maps.
	background.visible = true
	for child in get_children():
		if child.name.substr(0,4) == "Goal":
			# The pointers are not nesicery if the camera is not moving, as the goal is on the screen.
			if camera.moving == true:
				arrow_button.disabled = false
				arrow_button.visible = true
				var goalPointer = goalPointerLoader.instantiate()
				goalPointer.goal = child
				goalPointer.player = player
				CenterOfCanvas.add_child(goalPointer)
				gPointers.append(goalPointer)
			goals.append(child)
		elif child.has_signal("updateWorld"):
			child.connect("updateWorld", _worldUpdated)
	player.connect("death", _playerDeath)
	player.connect("playerDying", _playerDying)
	player.connect("goalReached", _goal_reached)
	player.connect("timeStop", _log_time)
	GameState.skip_intro = true

func getGoals():
	return goals

func mouseInput():
	if Input.is_action_pressed("PlayerPoint"):
		var mousePos = tile_map.get_local_mouse_position()
		var tilePos = tile_map.local_to_map(mousePos)
		
		var tileid = tile_map.get_cell_atlas_coords(0,tilePos)
		if tileid == Vector2i(0,0):
			player.grav(mousePos)
			gravitation.visible = true
			gravitation.position = mousePos
		elif tileid == Vector2i(0,1):
			player.grav(mousePos, 1)
			gravitation.visible = true
			gravitation.position = mousePos
		else:
			gravitation.visible = false
	else:
		gravitation.visible = false

func _physics_process(_d):
	mouseInput()
	background.position = camera.position

func _playerDying(cause):
	if !playerDying:
		var tween = create_tween()
		tween.tween_property(camera, "zoom", Vector2(1.3, 1.3), 1).set_trans(Tween.TRANS_QUAD)
		if !camera.moving:
			camera.set_physics_process(true)
		if cause == "blackhole":
			camera.position = player.position
			camera.set_physics_process(false)
		playerDying = true

func _goal_reached():
	get_tree().paused = true
	GameState.skip_intro = false
	completeMenu.visible = true

func _playerDeath():
	reload()

func _worldUpdated():
	emit_signal("updateChildren")

func reload():
	get_tree().reload_current_scene()

func _on_texture_button_pressed():
	get_tree().paused = true
	pause_menu.visible = true

func _on_fade_out():
	var nextLevel : String = "res://Levels/Level {0}.tscn".format([LevelNum+1])
	if FileAccess.file_exists(nextLevel):
		get_tree().change_scene_to_file(nextLevel)
	else:
		get_tree().change_scene_to_file("res://Levels/Level End.tscn")

func _on_arrow_button_pressed():
	for p in gPointers:
		p.reveal()

func _on_loadin_timeout():
	player.velocity = Vector2.ZERO
	player.set_physics_process(true)
	startTime = Time.get_ticks_msec()
	var fadetween = get_tree().create_tween()
	fadetween.tween_property(fade_transition, "modulate", Color(0, 0, 0, 0), 1)
	await fadetween.finished
	levelTitle.visible = false

func _on_continue_pressed():
	completeMenu.visible = false
	fade_transition.visible = true
	var fadetween = get_tree().create_tween()
	var tim = get_tree().create_timer(1)
	fadetween.tween_property(fade_transition, "modulate", Color(0, 0, 0, 1), 1)
	await tim.timeout
	_on_fade_out()

func _log_time():
	completeMenu.LevelWon((Time.get_ticks_msec() - startTime)/1000, LevelNum)
	get_tree().paused = false # Pauses the fucking game when sending data.
