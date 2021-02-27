extends Node

const SAVE_DIR = 'user://saves/'

var slot_screen_state = "new_game"
var file1 = false
var file2 = false
var file3 = false

var selected_slot = "1"

var save_path = SAVE_DIR + "game"+selected_slot+".dat"

var current_level = 1
var last_unlocked_level = 1
var deaths = 0
var pencils = 0
var checkpoint = 1

var game_data: Dictionary

var char_choosed = NORMAL

enum {
	NORMAL,
	GLASS,
	PIRATE,
}

func _ready():
	update_data()

func update_data():
	game_data = {
		"player_data": {
			"current_level": current_level,
			"last_unlock_level": last_unlocked_level,
			"checkpoint": checkpoint,
			"deaths": deaths,
			"pencils": pencils
		}
	}
	
func update_loaded_data():
	var player_data = game_data["player_data"]
	
	current_level = player_data["current_level"]
	last_unlocked_level = player_data["last_unlock_level"]
	deaths = player_data["deaths"]
	pencils = player_data["pencils"]
	checkpoint = player_data["checkpoint"]

func save_game():
	save_path = SAVE_DIR + "save_slot_" + selected_slot + ".dat"
	var dir: Directory = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		# warning-ignore:return_value_discarded
		dir.make_dir_recursive(SAVE_DIR)
		
	var file: File = File.new()
#	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "teste")
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_line(to_json(game_data))
		file.close()

func load_game(slot):
	selected_slot = slot
	save_path = SAVE_DIR + "save_slot_" + selected_slot + ".dat"
	var file: File = File.new()
#	var error = file.open_encrypted_with_pass(save_path, File.READ, "teste")
	var error = file.open(save_path, File.READ)
	if error == OK:
		game_data = parse_json(file.get_as_text())
		update_loaded_data()
		file.close()
	
func new_game(slot):
	selected_slot = slot
	current_level = 1
	last_unlocked_level = 1
	deaths = 0
	pencils = 0
	checkpoint = 1
	save_game()
	
func check_slots():
	var file: File = File.new()
	file1 = file.file_exists(SAVE_DIR + "save_slot_1.dat")
	file2 = file.file_exists(SAVE_DIR + "save_slot_2.dat")
	file3 = file.file_exists(SAVE_DIR + "save_slot_3.dat")
