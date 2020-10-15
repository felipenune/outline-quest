extends Sprite

export var item_name = "DOUBLE_JUMP"

func _on_Area2D_body_entered(body):
	body.power_up(item_name)
	queue_free()
