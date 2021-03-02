extends Area2D

onready var level_controller = get_parent().get_parent().get_node("LevelController")

func _ready():
	if GameManager.pencil_data["level" + str(level_controller.current_level)] == true:
		self.visible = false

func _on_Pencil_body_entered(body):
	body.get_pencil()
	queue_free()
