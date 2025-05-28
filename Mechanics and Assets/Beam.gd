extends Sprite2D

var switch: bool
@onready var beam_collision : CollisionShape2D
@onready var beam_area = $BeamArea
var debug: bool = false
var dist : int = 0

func _ready():
	beam_collision = CollisionShape2D.new()
	beam_collision.shape = RectangleShape2D.new()
	beam_area.add_child(beam_collision)

func activate(b : bool):
	switch = b
	if switch:
		visible = true
		beam_area.monitoring = true
	else:
		visible = false
		beam_area.monitoring = false

func setCollision(rect: Rect2):
	beam_collision.shape.size = rect.size

func _on_beam_area_body_entered(body):
	if body.name == "Player":
		body.laserDeath()
