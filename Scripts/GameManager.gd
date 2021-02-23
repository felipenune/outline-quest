extends Node

var current_level = 1
var last_unlocked_level = 1
var checkpoint

var game_data: Dictionary

func _ready():
	update_data()

func update_data():
	game_data = {
		"player_data": {
			"current_level": current_level,
			"last_unlock_level": last_unlocked_level,
			"checkpoint": checkpoint
		}
	}
	
func update_loaded_data():
	var player_data = game_data["player_data"]
	
	current_level = player_data["current_level"]
	last_unlocked_level = player_data["last_unlock_level"]

func save_game():
	var file: File = File.new()
	file.open('res://saved_game/game.dat', File.WRITE)
	file.store_line(to_json(game_data))
	file.close()

func load_game():
	var file: File = File.new()
	file.open('res://saved_game/game.dat', File.READ)
	game_data = parse_json(file.get_as_text())
	
	update_loaded_data()
	
	file.close()
