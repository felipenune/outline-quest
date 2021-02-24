extends Control

func next_screen(state):
	GameManager.slot_screen_state = state
	# warning-ignore:return_value_discarded
	get_tree().change_scene('res://Scenes/TitleScreenScenes/SlotsScreen.tscn')

func _on_NewGameButton_pressed():
	next_screen("new_game")

func _on_ContinueButton_pressed():
	next_screen("load_game")

func _on_ExitButton_pressed():
	get_tree().quit()
