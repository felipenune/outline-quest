extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func go_to_worlds():
# warning-ignore:return_value_discarded
	get_tree().change_scene('res://Scenes/TitleScreenScenes/WorldScreen.tscn')


func _on_Normal_pressed():
	GameManager.char_choosed = GameManager.NORMAL
	go_to_worlds()


func _on_Glass_pressed():
	GameManager.char_choosed = GameManager.GLASS
	go_to_worlds()


func _on_Pirate_pressed():
	GameManager.char_choosed = GameManager.PIRATE
	go_to_worlds()
