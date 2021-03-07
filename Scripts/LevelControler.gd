extends Node

export (PackedScene) var next_level

export var needed_keys = 1
export var current_keys = 0

export var current_level = 1

onready var death_timer = $DeathTimer

var on_door = false

var pencil = false

func _ready():
	on_door = false
	current_keys = 0
	GameManager.current_level = current_level
	
	if current_level > GameManager.last_unlocked_level:
		GameManager.last_unlocked_level = current_level
	
	GameManager.update_data()
	GameManager.save_game()

func _process(_delta):
	if on_door:
		if Input.is_action_just_pressed("ui_up"):
			GameManager.pencil_data["level" + str(current_level)] = pencil
			GameManager.update_data()
			GameManager.save_game()
			var next = get_tree().change_scene_to(next_level)
			if next != OK:
				print("Error")

func start_death_timer(duration):
	death_timer.start(duration)

func _on_DeathTimer_timeout():
	GameManager.deaths += 1
	var reload = get_tree().reload_current_scene()
	if reload != OK:
		print("Error")
