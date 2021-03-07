extends Control

onready var continue_button = $Menu/CenterRow/Buttons/HBoxContainer2/ContinueButton

onready var selector1 = $Menu/CenterRow/Buttons/HBoxContainer/Label
onready var selector2 = $Menu/CenterRow/Buttons/HBoxContainer2/Label2
onready var selector3 = $Menu/CenterRow/Buttons/HBoxContainer3/Label3
onready var selector4 = $Menu/CenterRow/Buttons/HBoxContainer4/Label4

var current_selection = 1

func _ready():
	GameManager.check_slots()
	if !GameManager.file1 and !GameManager.file2 and !GameManager.file3:
		continue_button.disabled = true
		
func _process(_delta):
	set_selected()
	if Input.is_action_just_pressed("ui_down") and current_selection < 4:
		current_selection += 1
	if Input.is_action_just_pressed("ui_up") and current_selection > 1:
		current_selection -= 1
	if Input.is_action_just_pressed("ui_accept"):
		handle_selected()

func next_screen(state):
	GameManager.slot_screen_state = state
	var next = get_tree().change_scene('res://Scenes/TitleScreenScenes/SlotsScreen.tscn')
	if next != OK:
			print("Error")
	
func handle_selected():
	if current_selection == 1:
		next_screen("new_game")
	elif current_selection == 2 and not continue_button.disabled:
		next_screen("load_game")
	elif current_selection == 3:
		var options = get_tree().change_scene("res://Scenes/TitleScreenScenes/OptionsScreen.tscn")
		if options != OK:
			print("Error")
	elif current_selection == 4:
		get_tree().quit()

func set_selected():
	selector1.text = ""
	selector2.text = ""
	selector3.text = ""
	selector4.text = ""
	if current_selection == 1:
		selector1.text = ">"
	elif current_selection == 2:
		selector2.text = ">"
		if continue_button.disabled == true:
			selector2.modulate = Color8(90, 90 ,90, 255)
	elif current_selection == 3:
		selector3.text = ">"
	elif current_selection == 4:
		selector4.text = ">"

func _on_NewGameButton_pressed():
	next_screen("new_game")

func _on_ContinueButton_pressed():
	next_screen("load_game")

func _on_OptionsButton_pressed():
	var options = get_tree().change_scene("res://Scenes/TitleScreenScenes/OptionsScreen.tscn")
	if options != OK:
		print("Error")
	
func _on_ExitButton_pressed():
	get_tree().quit()
