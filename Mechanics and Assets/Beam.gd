extends Sprite2D

var switch: bool
@onready var beam_area = $BeamArea
@onready var beam_sound = $BeamSound
@onready var audio = $audio

var beam_collision : CollisionShape2D
var sound_collision : CollisionShape2D
var debug: bool = false
var dist : int = 0

func _ready():
	beam_collision = CollisionShape2D.new()
	beam_collision.shape = RectangleShape2D.new()
	beam_area.add_child(beam_collision)
	
	sound_collision = CollisionShape2D.new()
	sound_collision.shape = RectangleShape2D.new()
	beam_sound.add_child(sound_collision)

func activate(b : bool):
	switch = b
	if switch:
		visible = true
		beam_area.monitoring = true
	else:
		audio.stop()
		visible = false
		beam_area.monitoring = false

func setCollision(rect: Rect2):
	beam_collision.shape.size = rect.size
	sound_collision.shape.size = rect.size + Vector2(3000, 500)

func _on_beam_area_body_entered(body):
	if body.name == "Player":
		body.laserDeath()


func _on_beam_sound_body_entered(body):
	if body.name == "Player" and switch:
		audio.play()
		var tween = create_tween()
		tween.tween_property(audio, "volume_db", -10, 0.5)

func _on_beam_sound_body_exited(body):
	if body.name == "Player" and switch:
		var tween = create_tween()
		tween.tween_property(audio, "volume_db", -30, 0.5)
		await tween.finished
		audio.stop()
