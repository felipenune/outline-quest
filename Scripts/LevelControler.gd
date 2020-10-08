extends Node

export var next_level_path = "res://Scenes/LevelsScenes/Level1.tscn"

export var needed_keys = 1
export var current_keys = 0

export var current_level = 1

onready var death_timer = $DeathTimer

var on_door = false

func _ready():
	on_door = false
	current_keys = 0

func _process(_delta):
	if on_door:
		if Input.is_action_just_pressed("ui_up"):
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/LevelsScenes/Level" + str(current_level + 1) + ".tscn")

		if Input.is_action_just_pressed("ui_down") and current_level != 1:
	# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/LevelsScenes/Level" + str(current_level - 1) + ".tscn")
			
func start_death_timer(duration):
	death_timer.start(duration)


func _on_DeathTimer_timeout():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
