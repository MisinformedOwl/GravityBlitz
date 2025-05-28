extends Node2D

@onready var timer = $Timer
@onready var animation = $AnimatedSprite2D

var player
var goal
var dir

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	dir = player.position.direction_to(goal.position)
	position = Vector2(dir.x*200, dir.y*300)
	var angle = rad_to_deg(atan2(dir.y, dir.x))
	angle = round(fmod(angle + 495, 360)/45)
	animation.play("%d" % angle)

func dirToGoal(dir):
	dir

func reveal():
	print("test")
	animation.modulate = Color(1,1,1,1)
	timer.start()

func _on_timer_timeout():
	var tween = create_tween()
	tween.tween_property(animation, "modulate", Color(1,1,1,0), 2).set_trans(Tween.TRANS_QUAD)
