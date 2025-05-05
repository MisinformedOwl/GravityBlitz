extends CharacterBody2D

@onready var eyes = $Sprite/Eyes
@onready var fire = $Sprite/FireAnim
@onready var sprite = $Sprite

const SPEED = 300.0
const SPEEDTHRESHOLD = 13

signal death

var dying = false
var currSpeed
var tilesReady = true
var speedHit = 0

func _ready():
	fire.play()

func decodeVelocity(pos,dist,dir):
	velocity += (pos-global_position)/(dist/40)

func getspeedhit():
	return speedHit

func grav(pos):
	if not dying:
		var dist : float = pos.distance_to(position)
		var dir = rad_to_deg(atan2(pos.x, pos.y))
		decodeVelocity(pos,dist,dir)

func moveEyes():
	var vel = velocity.normalized()
	var speed = sqrt((velocity.x**2)+(velocity.y**2))/100
	eyes.position = vel*15
	eyes.moveEyes(vel)
	currSpeed = speed
	if speed >= SPEEDTHRESHOLD:
		eyes.changeExpression(1)
	else:
		eyes.changeExpression(0)

func moveFlame():
	if currSpeed >= SPEEDTHRESHOLD:
		fire.visible = true
		var dir = velocity.angle()+PI/2
		fire.rotation = dir
	else:
		fire.visible = false

func setShaderParameters():
	sprite.material.set_shader_parameter("speed", currSpeed)
	sprite.material.set_shader_parameter("dir", fire.rotation-PI/2)

func lockdownAnims():
	eyes.lockdown()

func pitfallDeath():
	lockdownAnims()
	z_index = -3
	$AnimationPlayer.play("Pitfall Death")

func dead():
	emit_signal("death")

func _physics_process(delta):
	velocity -= velocity/200
	var collision = move_and_collide(velocity*delta)
	if collision:
		speedHit = currSpeed
		if abs(collision.get_normal().x) == 1:
			velocity.x = velocity.bounce(Vector2(1,0)).x*0.6
		elif abs(collision.get_normal().y) == 1:
			velocity.y = velocity.bounce(Vector2(0,1)).y*0.6
		else:
			velocity = velocity.bounce(collision.get_normal())*0.6 # Further work required to ensure stable movement.
	moveEyes()
	moveFlame()
	setShaderParameters()

func _on_animation_player_animation_finished(anim_name):
	dead()
