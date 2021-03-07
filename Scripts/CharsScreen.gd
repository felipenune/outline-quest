extends Control

var current_selection = 1

onready var char1 = $Menu/CenterRow/Slots/Normal
onready var char2 = $Menu/CenterRow/Slots/Glass
onready var char3 = $Menu/CenterRow/Slots/Pirate

func _ready():
	current_selection = GameManager.char_choosed + 1

func _process(_delta):
	set_selected()
	if Input.is_action_just_pressed("ui_right") and current_selection < 3:
		current_selection += 1
	if Input.is_action_just_pressed("ui_left") and current_selection > 1:
		current_selection -= 1
	if Input.is_action_just_pressed("ui_accept"):
		handle_selected()
	if Input.is_action_just_pressed("ui_cancel"):
		var back = get_tree().change_scene("res://Scenes/TitleScreenScenes/SlotsScreen.tscn")
		if back != OK:
			print("Error")

func go_to_worlds():
	var world_scene = get_tree().change_scene('res://Scenes/TitleScreenScenes/WorldScreen.tscn')
	if world_scene != OK:
		print("Error")

func set_selected():
	clear_moldure()
	match current_selection:
		1:
			char1.get_node("Moldure").visible = true
		2:
			char2.get_node("Moldure").visible = true
		3:
			char3.get_node("Moldure").visible = true

func clear_moldure():
	char1.get_node("Moldure").visible = false
	char2.get_node("Moldure").visible = false
	char3.get_node("Moldure").visible = false

func handle_selected():
	if current_selection == 1 and !char1.disabled:
		GameManager.char_choosed = GameManager.NORMAL
		go_to_worlds()
	elif current_selection == 2 and !char2.disabled:
		GameManager.char_choosed = GameManager.GLASS
		go_to_worlds()
	elif current_selection == 3 and !char3.disabled:
		GameManager.char_choosed = GameManager.PIRATE
		go_to_worlds()
	else:
		return
	

func _on_Normal_pressed():
	GameManager.char_choosed = GameManager.NORMAL
	go_to_worlds()


func _on_Glass_pressed():
	GameManager.char_choosed = GameManager.GLASS
	go_to_worlds()


func _on_Pirate_pressed():
	GameManager.char_choosed = GameManager.PIRATE
	go_to_worlds()
