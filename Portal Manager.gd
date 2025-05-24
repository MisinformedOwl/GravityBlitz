extends Node2D

var passbook : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		if c.portalCode in passbook:
			var k : Portal = passbook.get(c.portalCode)
			c.partner = k
			k.partner = c
			passbook.erase(c.portalCode)
		else:
			passbook[c.portalCode] = c
