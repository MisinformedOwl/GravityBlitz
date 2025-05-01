extends TileMap

@onready var player = $"../Player"

var connected = false

func _process(delta):
	var tile_pos = local_to_map(player.global_position)
	if get_cell_source_id(-1,tile_pos) != -1 and not connected:
		var tween = create_tween()
		var globalcords = local_to_map(player.global_position)*128
		tween.tween_property(player,"velocity",Vector2.ZERO, 0.2)
		player.global_position = player.global_position.lerp(Vector2(globalcords.x+64, globalcords.y+64), delta*2)
		player.dying = true
		$Timer.start()
		connected = true


func _on_timer_timeout():
	player.pitfallDeath()
