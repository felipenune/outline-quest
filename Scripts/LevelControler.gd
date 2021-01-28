extends Node

export (PackedScene) var next_level

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
			get_tree().change_scene_to(next_level)
			
	debug()

func start_death_timer(duration):
	death_timer.start(duration)

func debug():
	if Input.is_action_just_pressed("ui_restart"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _on_DeathTimer_timeout():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
