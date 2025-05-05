extends Node2D

@onready var tile_map = $Floor
@onready var player = $Player
@onready var gravitation = $Gravitation
@onready var goal = $Goal

signal goal_reached
signal playerDeath

func _ready():
	for child in get_children():
		if child.name.substr(0,4) == "Goal":
			child.connect("body_entered", _goal_reached)
	player.connect("death", _playerDeath)

func mouseInput():
	if Input.is_action_pressed("PlayerPoint"):
		var mousePos = tile_map.get_local_mouse_position()
		var tilePos = tile_map.local_to_map(mousePos)
		
		var tileid = tile_map.get_cell_atlas_coords(0,tilePos)
		if tileid == Vector2i(0,0):
			player.grav(mousePos)
			gravitation.visible = true
			gravitation.position = mousePos
		else:
			gravitation.visible = false
	else:
		gravitation.visible = false


func _physics_process(_d):
	mouseInput()

func _goal_reached(_body):
	emit_signal("goal_reached")

func _playerDeath():
	emit_signal("playerDeath")

func reload():
	pass
