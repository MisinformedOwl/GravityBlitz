extends StaticBody2D

@onready var Animated = $Sprite

@onready var beam = $Beam
@export var Switch: bool = true
@onready var beamcast = $Beamcast

var space
var animateVal = 0
var range = 0
@onready var sprite_2d = $Sprite2D

func _ready():
	await get_tree().process_frame
	await get_tree().process_frame
	get_parent().connect("pressed", _onButtonPressed)
	get_parent().connect("updatekids", _onUpdate)
	manageBeam()

func _physics_process(delta):
	animateVal -= 25
	beam.texture.region = Rect2(0, animateVal, 256, range)
	if abs(animateVal) > range:
		animateVal = 0

func manageBeam():
	if Switch:
		Animated.play("On")
		recast()
		beam.activate(true, beam.texture.region)
		set_physics_process(true)
	else:
		Animated.play("Off")
		beam.activate(false, beam.texture.region)
		set_physics_process(false)

func recast():
	var pos = beamcast.get_collision_point()
	beam.global_position = global_position
	beam.global_position += ((pos-global_position)/2 * abs(beamcast.get_collision_normal()))
	range = global_position.distance_to(pos)
	beam.texture.region = Rect2(0, animateVal, 256, range)

func _onButtonPressed(boolean: bool):
	Switch = boolean
	manageBeam()

func _onUpdate():
	recast()
