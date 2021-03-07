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

var pencil_data: Dictionary = {
	"level1": false,
	"level2": false,
	"level3": false,
	"level4": false,
	"level5": false,
	"level6": false,
	"level7": false,
	"level8": false,
	"level9": false,
	"level10": false,
	"level11": false,
	"level12": false,
	"level13": false,
	"level14": false,
	"level15": false,
	"level16": false,
	"level17": false,
	"level18": false,
	"level19": false,
	"level20": false,
	"level21": false,
	"level22": false,
	"level23": false,
	"level24": false,
	"level25": false,
	"level26": false,
	"level27": false,
	"level28": false,
	"level29": false,
	"level30": false,
	"level31": false,
	"level32": false,
	"level33": false,
	"level34": false,
	"level35": false,
	"level36": false,
	"level37": false,
	"level38": false,
	"level39": false,
	"level40": false,
	"level41": false,
	"level42": false,
	"level43": false,
	"level44": false,
	"level45": false,
	"level46": false,
	"level47": false,
	"level48": false,
	"level49": false,
	"level50": false,
	"gold": false
}

var char_choosed = NORMAL

enum {
	NORMAL,
	GLASS,
	PIRATE,
}

func _ready():
	update_data()

func _process(_delta):
	debug()

func update_data():
	game_data = {
		"player_data": {
			"current_level": current_level,
			"last_unlock_level": last_unlocked_level,
			"checkpoint": checkpoint,
			"deaths": deaths,
			"pencils": pencils
		},
		
		"pencil_data": pencil_data
	}
	
func update_loaded_data():
	var player_data = game_data["player_data"]
	
	current_level = player_data["current_level"]
	last_unlocked_level = player_data["last_unlock_level"]
	deaths = player_data["deaths"]
	pencils = player_data["pencils"]
	checkpoint = player_data["checkpoint"]
	pencil_data = game_data["pencil_data"]

func save_game():
	save_path = SAVE_DIR + "save_slot_" + selected_slot + ".dat"
	var dir: Directory = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		var new_dir = dir.make_dir_recursive(SAVE_DIR)
		if new_dir != OK:
			print("Error")
		
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
	
func debug():
	if Input.is_action_just_pressed("ui_restart"):
		var restart = get_tree().reload_current_scene()
		if restart != OK:
			print("Error")
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
