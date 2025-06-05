extends Node2D

var passbook : Dictionary = {}
@onready var camera : Camera2D = $"../Camera2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		c.connect("portalled", ported)
		if c.portalCode in passbook:
			var k : Portal = passbook.get(c.portalCode)
			c.partner = k
			k.partner = c
			passbook.erase(c.portalCode)
		else:
			passbook[c.portalCode] = c

func ported():
	camera.position_smoothing_enabled = false
	await get_tree().process_frame
	camera.position_smoothing_enabled = true
