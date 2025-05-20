extends Area2D

@onready var sprite = $ButtonSprite
@onready var timer = $Timer
@onready var wires = $TileMap

@export var switch: bool = true

signal updatekids
signal pressed(boolean)

func _ready():
	get_parent().connect("updateChildren", updateChildren)
	sprite.z_index+=1 # No idea why the fuck this doesn't just work in the editor, but here we are.
	pressed.emit(switch)
	if switch:
		wires.tile_set.set_source_id(0,2)
		wires.tile_set.set_source_id(1,0)
		wires.tile_set.set_source_id(2,1)

func setWires():
	wires.tile_set.set_source_id(0,2)
	wires.tile_set.set_source_id(1,0)
	wires.tile_set.set_source_id(2,1)

func _on_body_entered(body):
	if sprite.animation == "default":
		if body.name == "Player":
			switch = !switch
			setWires()
			for c in get_children():
				if c.is_in_group("Activatable"):
					c.onButtonPressed(switch)
			timer.start()
			sprite.play("Pushed")

func _on_timer_timeout():
	sprite.play("default")

func updateChildren():
	for c in get_children():
		if c.is_in_group("Activatable"):
			c.onUpdate()
			
