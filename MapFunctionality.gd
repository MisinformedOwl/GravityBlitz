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
@onready var fade_out_timer = $FadeOutTimer
@onready var CenterOfCanvas = $"UI Layer/CenterOfCanvas"
@onready var arrow_display = $ArrowDisplay
@onready var arrow_button = $"UI Layer/ButtonContainer/MarginContainer2/ArrowButton"

@export var LevelNum : int = 0

var goals = []
var gPointers = []
var playerDying : bool = false

signal goal_reached
signal playerDeath
signal updateChildren

func _ready():
	
	CenterOfCanvas.position = get_viewport_rect().size/2
	fade_transition.visible = true
	var fadetween = get_tree().create_tween()
	fadetween.tween_property(fade_transition, "color", Color(0, 0, 0, 0), 1)
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
	var fadetween = get_tree().create_tween()
	fadetween.tween_property(fade_transition, "color", Color(0, 0, 0, 1), 1)
	fade_out_timer.start()

func _playerDeath():
	reload()

func _worldUpdated():
	emit_signal("updateChildren")

func reload():
	get_tree().reload_current_scene()

func _on_texture_button_pressed():
	get_tree().paused = true
	pause_menu.visible = true

func _on_fade_out_timer_timeout():
	var nextLevel : String = "res://Levels/Level {0}.tscn".format([LevelNum+1])
	if FileAccess.file_exists(nextLevel):
		get_tree().change_scene_to_file(nextLevel)
	else:
		get_tree().change_scene_to_file("res://Levels/Level End.tscn")


func _on_arrow_button_pressed():
	for p in gPointers:
		p.reveal()
