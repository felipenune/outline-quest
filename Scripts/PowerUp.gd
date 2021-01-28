extends Node2D

export var item_name = "DOUBLE_JUMP"
export var color1: Color = Color.white
export var color2: Color = Color.white

onready var sprite = $Sprite

func _process(_delta):
	pass
#	var view_port = get_viewport().size
#
#	if view_port.x >= 1280 and view_port.y >= 720:
#		sprite.modulate = color1
#	else:
#		sprite.modulate = color2
	

func _on_Area2D_body_entered(body):
	body.power_up(item_name)
	queue_free()
