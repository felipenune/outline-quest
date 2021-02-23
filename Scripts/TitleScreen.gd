extends Control

func _ready():
	GameManager.load_game()
	

func _on_NewGameButton_pressed():
	get_tree().change_scene('res://Scenes/LevelsScenes/Level1.tscn')
