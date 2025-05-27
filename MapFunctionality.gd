extends Node2D

var goalPointerLoader = preload("res://Mechanics and Assets/GoalPointer.tscn")

@onready var tile_map = $Floor
@onready var player = $Player
@onready var gravitation = $Gravitation
@onready var camera = $Camera2D
@onready var background = $Background
@onready var ui = $"UI Layer"
@onready var pause_menu = $"UI Layer/Pause Menu"


@export var LevelNum : int = 0

var goals = []
var gPointers = []
var playerDying : bool = false

signal goal_reached
signal playerDeath
signal updateChildren

func _ready():
	background.visible = true
	for child in get_children():
		if child.name.substr(0,4) == "Goal":
			# The pointers are not nesicery if the camera is not moving, as the goal is on the screen.
			if camera.moving == true:
				var goalPointer = goalPointerLoader.instantiate()
				goalPointer.goal = child
				add_child(goalPointer)
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
	var nextLevel : String = "res://Levels/Level {0}.tscn".format([LevelNum+1])
	if FileAccess.file_exists(nextLevel):
		get_tree().change_scene_to_file(nextLevel)
	else:
		get_tree().change_scene_to_file("res://Levels/Level End.tscn")

func _playerDeath():
	reload()

func _worldUpdated():
	emit_signal("updateChildren")

func reload():
	get_tree().reload_current_scene()

func _on_texture_button_pressed():
	get_tree().paused = true
	pause_menu.visible = true
