extends Area2D

var playerInGrav: bool = false
var player: CharacterBody2D
@export var gravMult: float = 1.0
@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("Default")
	set_physics_process(false)

func _on_body_entered(body):
	if body.name == "Player":
		gravMult = 20.0
		body.blackHoleDeath(position)

func _physics_process(_delta):
	player.grav(global_position, false, lerp(1.0*gravMult, 0.0, clamp(player.global_position.distance_to(global_position) / 1000.0, 0.0, 1.0)))

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player = body
		set_physics_process(true)

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		set_physics_process(false)
