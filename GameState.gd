extends Node

var skip_intro = false
const SAVE_PATH = "user://savegame.ini"
var player_data = {"current_level": 1, "stars": {}}

func _ready():
	load_game()

func save_game():
	var config = ConfigFile.new()
	config.set_value("Progress", "current_level", player_data.current_level)
	for level in player_data.stars:
		config.set_value("Stars", str(level), player_data.stars[level])
	config.save(SAVE_PATH)

func load_game():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		player_data.current_level = config.get_value("Progress", "current_level", 1)
		player_data.stars.clear()
		for key in config.get_section_keys("Stars"):
			player_data.stars[int(key)] = config.get_value("Stars", key)

func update_progress(level: int, stars: int):
	player_data.current_level = max(player_data.current_level, level + 1)
	player_data.stars[level] = max(player_data.stars.get(level, 0), stars)
	save_game()

func get_current_level() -> int:
	return player_data.current_level

func get_stars(level: int) -> int:
	return player_data.stars.get(level, 0)
