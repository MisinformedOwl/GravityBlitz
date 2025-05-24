class_name Portal
extends Area2D

@export var portalCode : int = 0

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var portalOutput : Marker2D = $Marker2D
@onready var sickness = $Sickness

var partner : Portal
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")

func _on_body_entered(body):
	if body.name == "Player" and body.TPSickness == false:
		body.position = partner.portalOutput.global_position
		changeVelocity(body)
		body.TPSickness = true
		player = body
		sickness.start()

func changeVelocity(player):
	# Get rotations (in radians, as Godot's rotation property is in radians)
	var entry_rotation = rotation
	var partner_rotation = partner.rotation

	# Calculate relative rotation (how much to rotate velocity to align with partner portal)
	var relative_angle = partner_rotation - entry_rotation

	# Store original velocity components
	var old_x = player.velocity.x
	var old_y = player.velocity.y

	# Apply 2D rotation: [x, y] -> [x*cos(θ) - y*sin(θ), x*sin(θ) + y*cos(θ)]
	player.velocity.x = old_x * cos(relative_angle) - old_y * sin(relative_angle)
	player.velocity.y = old_x * sin(relative_angle) + old_y * cos(relative_angle)

	# Ensure velocity magnitude is preserved (optional, to handle floating-point errors)
	var original_speed = player.velocity.length()
	if original_speed > 0:
		player.velocity = player.velocity.normalized() * original_speed

func _on_timer_timeout():
	player.TPSickness = false
