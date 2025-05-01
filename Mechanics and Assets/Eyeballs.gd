extends Sprite2D

var lock = false

func _on_animated_sprite_2d_frame_changed():
	if not lock:
		visible = !visible
