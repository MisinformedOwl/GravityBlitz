extends Camera2D

@export var moving = false
@onready var player = $"../Player"
@onready var flooring = $"../Floor"

# Called when the node enters the scene tree for the first time.
func _ready():
	if !moving:
		set_physics_process(false)

func _physics_process(_delta):
	position = player.position
