extends TileMap

@onready var player = $"../Player"
var tile_pos : Vector2
var tween

func _ready():
	tween = get_tree().create_tween()
	set_physics_process(false)
	player.connect("movedATile", _playerMoved)

func _playerMoved():
	tile_pos = local_to_map(player.global_position)
	if get_cell_source_id(-1,tile_pos) != -1:
		player.dying = true
		$Timer.start()
		set_physics_process(true)

func _physics_process(delta):
	var targetTile = tile_pos*128
	targetTile = Vector2(targetTile.x+64, targetTile.y+64)
	player.position -= (player.position-(targetTile))/50
	player.velocity /= 2
	player.move_and_collide(player.velocity*delta)
	#tween.property(player, "velocity",Vector2(), 1)
	#tween.property(player, "position", targetTile, 1)

func _on_timer_timeout():
	player.pitfallDeath()
