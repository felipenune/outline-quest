extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Normal_pressed():
	GameManager.char_choosed = GameManager.NORMAL
	get_tree().change_scene('res://Scenes/LevelsScenes/Level1.tscn')


func _on_Glass_pressed():
	GameManager.char_choosed = GameManager.GLASS
	get_tree().change_scene('res://Scenes/LevelsScenes/Level1.tscn')


func _on_Pirate_pressed():
	GameManager.char_choosed = GameManager.PIRATE
	get_tree().change_scene('res://Scenes/LevelsScenes/Level1.tscn')
