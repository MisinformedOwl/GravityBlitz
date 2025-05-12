extends Node

var CurrentLevel = 20
var transitioning
var Limit = 1

var exitPort = null

#===============================================================================

func LoadMap(name=""):
	var newMap
	if len(name) == 0:
		newMap = load("res://Levels/Level {0}.tscn".format([CurrentLevel])).instantiate()
		print("Loading level {0}".format([CurrentLevel]))
	else:
		newMap = load("res://Levels/{0}.tscn".format([name])).instantiate()
		print("Loading level {0}".format([name]))
	newMap.connect("goal_reached", _on_goal_reached)
	newMap.connect("playerDeath", _restart)
	add_child(newMap)

#===============================================================================

func _ready():
	LoadMap("Level 22")

#===============================================================================

func _on_goal_reached():
	get_child(0).queue_free()
	CurrentLevel+=1
	LoadMap()

func _restart():
	print("Restarting")
	get_child(0).queue_free()
	LoadMap()
