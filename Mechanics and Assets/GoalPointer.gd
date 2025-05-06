extends Node2D

@onready var camera = $"../Camera2D"
var goal
@onready var animation = $AnimatedSprite2D

func _ready():
	reparent(camera)
	position = Vector2.ZERO

func pointerPos():
	var dir = camera.global_position.direction_to(goal.global_position)
	position = Vector2(dir.x*500, dir.y*600)
	var angle = rad_to_deg(atan2(dir.y, dir.x))
	angle = round(fmod(angle + 495, 360)/45)
	animation.play("%d" % angle)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.distance_to(goal.global_position) > 10:
		visible = true
		pointerPos()
	else:
		visible = false
