extends Sprite2D

var switch: bool
@onready var beam_collision = $BeamArea/BeamCollision
@onready var beam_area = $BeamArea

func activate(b : bool, rect : Rect2):
	switch = b
	if switch:
		visible = true
		beam_area.monitoring = true
		setCollision(rect)
	else:
		visible = false
		beam_area.monitoring = false

func setCollision(rect: Rect2):
	beam_collision.shape.size = rect.size

func _on_beam_area_body_entered(body):
	if body.name == "Player":
		body.laserDeath()
