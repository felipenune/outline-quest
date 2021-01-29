extends Node2D

onready var animation = $AnimatedSprite

func bounce(bouncer):
	if bouncer.has_method("spring"):
		bouncer.spring()
		animation.play("up")


func _on_AnimatedSprite_animation_finished():
	if animation.animation == "up":
		animation.play("down")
