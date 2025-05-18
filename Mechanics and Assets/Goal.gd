extends Area2D
@onready var sprite = $Sprite

func _ready():
	sprite.play("default")
