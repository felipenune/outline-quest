extends Control

onready var continue_button = $Menu/CenterRow/Buttons/ContinueButton

func _ready():
	GameManager.check_slots()
	if !GameManager.file1 and !GameManager.file2 and !GameManager.file3:
		continue_button.disabled = true

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
