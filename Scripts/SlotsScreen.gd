extends Control

var selected_slot = "1"

export var next_scene: PackedScene

onready var warning = $Warning

onready var title = $Menu/RichTextLabel

onready var slot1 = $Menu/CenterRow/Slots/slot1
onready var slot2 = $Menu/CenterRow/Slots/slot2
onready var slot3 = $Menu/CenterRow/Slots/slot3

func _ready():
	GameManager.check_slots()
	if GameManager.slot_screen_state == "new_game":
		title.bbcode_text = "[center]Select one slot to save[/center]"
	elif GameManager.slot_screen_state == "load_game":
		title.bbcode_text = "[center]Select one slot to load[/center]"
		disable_slots()

func new_game(slot):
	GameManager.new_game(slot)
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(next_scene)
	
func next_screen(slot, file_exist):
	selected_slot = slot
	if GameManager.slot_screen_state == "new_game":
		if file_exist:
			warning.visible = true
		else:
			new_game(slot)
	elif GameManager.slot_screen_state == "load_game":
		GameManager.load_game(slot)
		# warning-ignore:return_value_discarded
		get_tree().change_scene_to(next_scene)

func disable_slots():
	if !GameManager.file1:
		slot1.disabled = true
	if !GameManager.file2:
		slot2.disabled = true
	if !GameManager.file3:
		slot3.disabled = true

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
