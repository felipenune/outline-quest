extends StaticBody2D

onready var animation = $AnimatedSprite
onready var level_controller= get_parent().get_node("LevelController")

func _on_Area2D_body_entered(_body):
	if animation.animation == "up":
		level_controller.current_keys += 1
	animation.play("down")
