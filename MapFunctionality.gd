extends Node2D

var goalPointerLoader = preload("res://Mechanics and Assets/GoalPointer.tscn")

@onready var tile_map = $Floor
@onready var player = $Player
@onready var gravitation = $Gravitation
@onready var camera = $Camera2D
@onready var background = $Background

var goals = []
var gPointers = []
var playerDying : bool = false

signal goal_reached
signal playerDeath
signal updateChildren

func _ready():
	var map = $Wall
	if map:
		var used_cells = map.get_used_cells(0)  # Check layer 0
		for cell in used_cells:
			var atlas_coords = map.get_cell_atlas_coords(0, cell)
			if atlas_coords.x > 3 or atlas_coords.y > 3:
				print("Invalid tile found at cell: ", cell, " with atlas coords: ", atlas_coords)

	background.visible = true
	for child in get_children():
		if child.name.substr(0,4) == "Goal":
			# The pointers are not nesicery if the camera is not moving, as the goal is on the screen.
			if camera.moving == true:
				var goalPointer = goalPointerLoader.instantiate()
				goalPointer.goal = child
				add_child(goalPointer)
			child.connect("body_entered", _goal_reached)
			goals.append(child)
		elif child.has_signal("updateWorld"):
			child.connect("updateWorld", _worldUpdated)
	player.connect("death", _playerDeath)
	player.connect("playerDying", _playerDying)

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

func _goal_reached(_body):
	emit_signal("goal_reached")

func _playerDeath():
	emit_signal("playerDeath")

func _worldUpdated():
	emit_signal("updateChildren")

func reload():
	pass
