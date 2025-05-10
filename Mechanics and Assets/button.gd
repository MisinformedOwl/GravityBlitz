extends Area2D

@onready var sprite = $ButtonSprite
@onready var timer = $Timer

signal pressed

func _on_body_entered(body):
	if sprite.animation == "default":
		if body.name == "Player":
			emit_signal("pressed")
			timer.start()
			sprite.play("Pushed")

func _on_timer_timeout():
	sprite.play("default")
