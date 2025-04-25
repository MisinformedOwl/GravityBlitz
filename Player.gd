extends CharacterBody2D

@onready var shader_floor = $"../TileMap/ShaderFloor"
@onready var eyes = $Sprite/Eyes

const SPEED = 300.0

var currSpeed
var tilesReady = true

func decodeVelocity(pos,dist,dir):
	velocity += (pos-global_position)/(dist/40)

func getspeed():
	return currSpeed

func grav(pos):
	var dist : float = pos.distance_to(position)
	var dir = rad_to_deg(atan2(pos.x, pos.y))
	decodeVelocity(pos,dist,dir)

func moveEyes():
	var vel = velocity.normalized()
	var speed = sqrt((velocity.x**2)+(velocity.y**2))/100
	eyes.position = vel*15
	eyes.moveEyes(vel)
	currSpeed = speed
	if speed > 10:
		eyes.changeExpression(1)
	else:
		eyes.changeExpression(0)

func _physics_process(delta):
	velocity -= velocity/200
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())*0.6
	
	moveEyes()
