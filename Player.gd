extends CharacterBody2D

@onready var eyes = $Eyes
@onready var fire = $FireAnim
@onready var sprite = $Sprite

const SPEEDTHRESHOLD = 13

signal death
signal movedATile
signal playerDying

var dying             : bool = false
var currSpeed         : float
var tilesReady        : bool = true
var speedHit          : float = 0
var speed             : float = 0.0
var dir               : float = 0

var tileChecker       : Vector2 = Vector2(0,0)

var shaders = [preload("res://Shaders/laserDeath.gdshader")]

func _ready():
	fire.play()

func decodeVelocity(pos,dist,dir, inverse : int = 0, str: float = 1):
	velocity += ((pos-global_position)/(dist/40) * (1 - 2 * inverse) * str)

func getspeedhit():
	return speedHit

func grav(pos, inverse: bool = false, str: float = 1):
	if not dying:
		var dist : float = pos.distance_to(position)
		var dir = rad_to_deg(atan2(pos.x, pos.y))
		decodeVelocity(pos,dist,dir, inverse, str)

func moveEyes():
	var vel = velocity.normalized()
	speed = sqrt((velocity.x**2)+(velocity.y**2))/100
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
		dir = velocity.angle()+PI/2
		fire.rotation = dir
	else:
		fire.visible = false

func lockdownAnims():
	eyes.lockdown()

func laserDeath():
	print(dying)
	if !dying:
		sprite.rotation = 0
		lockdownAnims()
		moveCameraDeath()
		var ShaderMat = ShaderMaterial.new()
		ShaderMat.shader = shaders[0]
		ShaderMat.set_shader_parameter("time", Time.get_ticks_msec()/1000)
		sprite.material = ShaderMat
		eyes.material = ShaderMat
		eyes.closeEyes()
		dying = true

func blackHoleDeath():
	dead()

func pitfallDeath():
	moveCameraDeath()
	set_physics_process(false)
	lockdownAnims()
	$AnimationPlayer.play("Pitfall Death")

func dead():
	emit_signal("death")

func moveCameraDeath():
	emit_signal("playerDying")

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
	var playertile = position/128
	if !dying:
		if tileChecker.x != int(playertile.x):
			emit_signal("movedATile")
			tileChecker.x = int(playertile.x)
		elif tileChecker.y != int(playertile.y):
			emit_signal("movedATile")
			tileChecker.y = int(playertile.y)
	moveEyes()
	moveFlame()
	if !dying:
		setSpriteAnim()
	else:
		velocity -= velocity/10

func setSpriteAnim():
	sprite.rotation = dir
	if speed > SPEEDTHRESHOLD:
		if sprite.animation == "default":
			sprite.play("Heatup")
	else:
		sprite.play("default")

func _on_animation_player_animation_finished(anim_name):
	dead()

func _on_sprite_animation_finished():
	if sprite.animation == "Heatup":
		sprite.play("Fast")
