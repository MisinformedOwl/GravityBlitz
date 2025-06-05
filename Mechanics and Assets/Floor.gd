extends TileMap

@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("movedATile", _playerMoved)

func _playerMoved():
	var tile_pos = local_to_map(player.global_position)
	if get_cell_source_id(-1,tile_pos) == -1:
		player.friction = false
	else:
		player.friction = true
