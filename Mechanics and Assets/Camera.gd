extends Camera2D

@export var moving = false
@onready var player = $"../Player"
@onready var floor = $"../Floor"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(moving)
	if moving:
		var area = floor.get_used_rect()
		area.position = (area.position * 128)-Vector2i(128,128)
		area.size = (area.size * 128)+Vector2i(128,128)*2
		print(area)
		
		limit_left = area.position.x
		limit_right = area.position.x+area.size.x
		limit_top = area.position.y
		limit_bottom = area.position.y+area.size.y
	else:
		set_physics_process(false)

func _physics_process(_delta):
	print("Running %f" % Time.get_ticks_msec())
	position = player.position
