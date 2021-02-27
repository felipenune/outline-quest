extends Control

export(Array, PackedScene) var levels

var world = 1

onready var world_button = $Menu/CenterRow/WorldButton


func _ready():
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_just_pressed("ui_right") and world < 5:
		world += 1
	if Input.is_action_just_pressed("ui_left") and world > 1:
		world -= 1
	
	world_button.text = "World " + str(world)
	
	check_world(GameManager.last_unlocked_level)

func check_world(last_level):
	if last_level <= 10 and world > 1:
		world_button.disabled = true
	elif last_level <= 20 and world > 2:
		world_button.disabled = true
	elif last_level <= 30 and world > 3:
		world_button.disabled = true
	elif last_level <= 40 and world > 4:
		world_button.disabled = true
	else:
		world_button.disabled = false

func _on_WorldButton_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(levels[world - 1])
