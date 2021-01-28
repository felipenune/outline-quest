extends StaticBody2D

onready var animation = $AnimatedSprite

func _on_Area2D_body_entered(body):
	body.spring()
	animation.play("down")


func _on_Area2D_body_exited(_body):
	animation.play("up")
