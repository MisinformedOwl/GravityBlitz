extends AnimatedSprite2D

@onready var eyeball = $Eyeball
var currentAnim = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	play("default")


func moveEyes(vel):
	vel.x*=2
	eyeball.position = vel*10

func changeExpression(which):
	if currentAnim != which:
		currentAnim = which
		if which == 1:
			play("fast")
		else:
			play("default")
