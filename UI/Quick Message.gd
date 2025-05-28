extends PanelContainer
@onready var timer = $Timer

func _ready():
	timer.start()

func _on_timer_timeout():
	var tween = create_tween()
	tween.connect("finished", _on_tween_finished)
	tween.tween_property(self, "modulate", Color(1,1,1,0), 2)

func _on_tween_finished():
	queue_free()
