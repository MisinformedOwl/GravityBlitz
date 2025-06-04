extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var timer = $Timer
@onready var audio = $AudioStreamPlayer

var dying = false
var shader = preload("res://Shaders/dissolve.gdshader")

var collision : CollisionShape2D
var detection : CollisionShape2D
@onready var area_2d = $Area2D

signal updateWorld

func _ready():
	set_physics_process(false)
	collision = CollisionShape2D.new()
	detection = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	detection.shape = RectangleShape2D.new()
	
	var sizes = sprite.get_texture().get_size()*sprite.scale
	
	collision.shape.size = Vector2(sizes.x,sizes.y)
	detection.shape.size = Vector2(sizes.x+5,sizes.y+5)
	
	add_child(collision)
	area_2d.add_child(detection)

func _on_area_2d_body_entered(body):
	if body.name == "Player" and dying == false:
		if body.getspeedhit() >= body.SPEEDTHRESHOLD:
			audio.play()
			set_physics_process(true)
			dying = true
			var noise = NoiseTexture2D.new()
			var mat = ShaderMaterial.new()
			
			noise.noise = FastNoiseLite.new()
			
			mat.shader = shader
			mat.set_shader_parameter("noise_texture", noise)
			mat.set_shader_parameter("t", Time.get_ticks_msec() / 1000.0-0.3)

			sprite.material = mat
			timer.start()

func _physics_process(_delta):
		collision.disabled = true
		detection.disabled = true
		await get_tree().process_frame
		emit_signal("updateWorld")
		await get_tree().process_frame
		set_physics_process(false)

func _on_timer_timeout():
	queue_free()
