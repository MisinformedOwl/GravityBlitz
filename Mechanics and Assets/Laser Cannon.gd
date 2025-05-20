extends StaticBody2D

@onready var Animated = $Sprite

@onready var beam = $Beam
@export var Switch: bool = true
@onready var beamcast = $Beamcast

@export var debugmode: bool = false

var space
var animateVal = 0
var dist = 0

func _ready():
	await get_tree().process_frame
	await get_tree().process_frame
	manageBeam()

func _physics_process(_delta):
	animateVal -= 25
	beam.texture.region = Rect2(0, animateVal, 256, dist)
	if abs(animateVal) > dist:
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
	if debugmode:
		print(pos)
	beam.global_position = global_position
	beam.global_position += ((pos-global_position)/2 * abs(beamcast.get_collision_normal()))
	dist = global_position.distance_to(pos)
	beam.texture.region = Rect2(0, animateVal, 256, dist)

func onButtonPressed(boolean: bool):
	Switch = boolean
	manageBeam()

func onUpdate():
	await get_tree().process_frame
	recast()
