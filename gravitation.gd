extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	$GravityAnimation.play("default")
