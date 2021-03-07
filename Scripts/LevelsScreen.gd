extends Control

var current_selection = 1

export(int) var world_control
export(Array, PackedScene) var levels

onready var level1 = $Menu/CenterRow/Levels/Level1
onready var level2 = $Menu/CenterRow/Levels/Level2
onready var level3 = $Menu/CenterRow/Levels/Level3
onready var level4 = $Menu/CenterRow/Levels/Level4
onready var level5 = $Menu/CenterRow/Levels/Level5

onready var level6 = $Menu/CenterRow/Levels2/Level6
onready var level7 = $Menu/CenterRow/Levels2/Level7
onready var level8 = $Menu/CenterRow/Levels2/Level8
onready var level9 = $Menu/CenterRow/Levels2/Level9
onready var level10 = $Menu/CenterRow/Levels2/Level10

func _process(_delta):
	set_selected()
	if Input.is_action_just_pressed("ui_right") and current_selection < 10:
		current_selection += 1
	if Input.is_action_just_pressed("ui_left") and current_selection > 1:
		current_selection -= 1
	if Input.is_action_just_pressed("ui_down") and current_selection < 6:
		current_selection += 5
	if Input.is_action_just_pressed("ui_up") and current_selection > 5:
		current_selection -= 5
	if Input.is_action_just_pressed("ui_accept"):
		handle_selected()
	if Input.is_action_just_pressed("ui_cancel"):
		var back = get_tree().change_scene("res://Scenes/TitleScreenScenes/WorldScreen.tscn")
		if back != OK:
			print("Error")

func handle_selected():
	if current_selection + world_control > GameManager.last_unlocked_level:
		return
	go_to_level(current_selection)

func set_selected():
	clear_moldure()
	match current_selection:
		1:
			level1.get_node("Moldure").visible = true
		2:
			level2.get_node("Moldure").visible = true
		3:
			level3.get_node("Moldure").visible = true
		4:
			level4.get_node("Moldure").visible = true
		5:
			level5.get_node("Moldure").visible = true
		6:
			level6.get_node("Moldure").visible = true
		7:
			level7.get_node("Moldure").visible = true
		8:
			level8.get_node("Moldure").visible = true
		9:
			level9.get_node("Moldure").visible = true
		10:
			level10.get_node("Moldure").visible = true

func clear_moldure():
	level1.get_node("Moldure").visible = false
	level2.get_node("Moldure").visible = false
	level3.get_node("Moldure").visible = false
	level4.get_node("Moldure").visible = false
	level5.get_node("Moldure").visible = false
	level6.get_node("Moldure").visible = false
	level7.get_node("Moldure").visible = false
	level8.get_node("Moldure").visible = false
	level9.get_node("Moldure").visible = false
	level10.get_node("Moldure").visible = false

func go_to_level(level):
	var level_scene = get_tree().change_scene_to(levels[level - 1])
	if level_scene != OK:
		print("Error")
	
func _on_Level1_pressed():
	go_to_level(1)


func _on_Level2_pressed():
	go_to_level(2)


func _on_Level3_pressed():
	go_to_level(3)


func _on_Level4_pressed():
	go_to_level(4)
	
	
func _on_Level5_pressed():
	go_to_level(5)


func _on_Level6_pressed():
	go_to_level(6)


func _on_Level7_pressed():
	go_to_level(7)


func _on_Level8_pressed():
	go_to_level(8)


func _on_Level9_pressed():
	go_to_level(9)


func _on_Level10_pressed():
	go_to_level(10)


