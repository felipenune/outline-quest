extends Control

var selected_slot = "1"

export var next_scene: PackedScene

onready var warning = $Warning

onready var title = $Menu/RichTextLabel

onready var slot1 = $Menu/CenterRow/Slots/HBoxContainer/slot1
onready var slot2 = $Menu/CenterRow/Slots/HBoxContainer2/slot2
onready var slot3 = $Menu/CenterRow/Slots/HBoxContainer3/slot3

onready var selector1 = $Menu/CenterRow/Slots/HBoxContainer/Label
onready var selector2 = $Menu/CenterRow/Slots/HBoxContainer2/Label2
onready var selector3 = $Menu/CenterRow/Slots/HBoxContainer3/Label3

var current_selection = 1

func _ready():
	GameManager.check_slots()
	if GameManager.slot_screen_state == "new_game":
		title.bbcode_text = "[center]Select one slot to save[/center]"
	elif GameManager.slot_screen_state == "load_game":
		title.bbcode_text = "[center]Select one slot to load[/center]"
		disable_slots()
		init_selection()

func _process(_delta):
	set_selected()
	handle_nav()
	if !warning.visible:
		if Input.is_action_just_pressed("ui_accept"):
			handle_selected()
		if Input.is_action_just_pressed("ui_cancel"):
			var back = get_tree().change_scene("res://Scenes/TitleScreenScenes/TitleScreen.tscn")
			if back != OK:
				print("Error")
	else:
		if Input.is_action_just_pressed("ui_accept"):
			new_game(selected_slot)
		if Input.is_action_just_pressed("ui_cancel"):
			warning.visible = false

func new_game(slot):
	GameManager.new_game(slot)
	var next = get_tree().change_scene_to(next_scene)
	if next != OK:
		print("Error")
	
func next_screen(slot, file_exist):
	selected_slot = slot
	if GameManager.slot_screen_state == "new_game":
		if file_exist:
			warning.visible = true
		else:
			new_game(slot)
	elif GameManager.slot_screen_state == "load_game":
		GameManager.load_game(slot)
		var next = get_tree().change_scene_to(next_scene)
		if next != OK:
			print("Error")

func disable_slots():
	if !GameManager.file1:
		slot1.disabled = true
	if !GameManager.file2:
		slot2.disabled = true
	if !GameManager.file3:
		slot3.disabled = true

func handle_selected():
	if (current_selection == 1 and slot1.disabled == true) or (current_selection == 2 and slot2.disabled == true) or (current_selection == 3 and slot3.disabled == true):
		return
	var selected_file
	match current_selection:
		1:
			selected_file = GameManager.file1
		2:
			selected_file = GameManager.file2
		3:
			selected_file = GameManager.file3
	next_screen(str(current_selection), selected_file)

func set_selected():
	selector1.text = ""
	selector2.text = ""
	selector3.text = ""	
	if current_selection == 1:
		selector1.text = ">"
		if slot1.disabled == true:
			selector1.modulate = Color8(90, 90 ,90, 255)
	elif current_selection == 2:
		selector2.text = ">"
		if slot2.disabled == true:
			selector2.modulate = Color8(90, 90 ,90, 255)
	elif current_selection == 3:
		selector3.text = ">"
		if slot3.disabled == true:
			selector3.modulate = Color8(90, 90 ,90, 255)

func init_selection():
	if !GameManager.file1 and current_selection == 1:
		if GameManager.file2:
			current_selection = 2
		else:
			current_selection = 3
			
func handle_nav():
	if Input.is_action_just_pressed("ui_down") and current_selection < 3:
		current_selection += 1
	if Input.is_action_just_pressed("ui_up") and current_selection > 1:
		current_selection -= 1

func _on_slot1_pressed():
	next_screen("1", GameManager.file1)

func _on_slot2_pressed():
	next_screen("2", GameManager.file2)

func _on_slot3_pressed():
	next_screen("3", GameManager.file3)
	
func _on_OK_pressed():
	new_game(selected_slot)

func _on_Cancel_pressed():
	warning.visible = false
