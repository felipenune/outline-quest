extends Position2D

onready var PlayerScene = preload("res://Scenes/PlayerScenes/Player.tscn")

func _ready():
	var player = PlayerScene.instance()
	get_parent().call_deferred("add_child", player)
	player.global_position = global_position
