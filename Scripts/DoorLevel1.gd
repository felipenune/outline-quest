extends Node2D

onready var level_controller = get_parent().get_node("LevelController")
onready var animation = $AnimatedSprite

func _process(_delta):
	if level_controller.current_keys == level_controller.needed_keys:
		animation.play("open")


func _on_Area2D_body_entered(_body):
	level_controller.on_door = true


func _on_Area2D_body_exited(_body):
	level_controller.on_door = false
