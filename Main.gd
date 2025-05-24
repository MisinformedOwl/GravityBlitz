extends Node

var CurrentLevel = 36
var transitioning
var Limit = 1

var exitPort = null

#===============================================================================

func LoadMap(nameOfMap=""):
	var newMap
	if nameOfMap == "":
		newMap = load("res://Levels/Level {0}.tscn".format([CurrentLevel])).instantiate()
		print("Loading level {0}".format([CurrentLevel]))
	else:
		newMap = load("res://Levels/{0}.tscn".format([nameOfMap])).instantiate()
		print("Loading level {0}".format([nameOfMap]))
	newMap.connect("goal_reached", _on_goal_reached)
	newMap.connect("playerDeath", _restart)
	add_child(newMap)

#===============================================================================

func _ready():
	LoadMap("Level 36")

#===============================================================================

func _on_goal_reached():
	get_child(0).queue_free()
	CurrentLevel+=1
	call_deferred("LoadMap")

func _restart():
	print("Restarting")
	get_child(0).queue_free()
	LoadMap()
