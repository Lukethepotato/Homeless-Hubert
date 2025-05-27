extends Node

# This is a global script which manages saving and loading player data from save files written in JSON. The data is typically loaded in the main_menu.gd file under the function start_game

var current_file := 1;#: int;

func save_data() -> bool:
	var save_file = FileAccess.open("user://save_file_"+str(current_file)+".save", FileAccess.WRITE);
	##### ↓ REALLY IMPORTANT: Modifying the parts of this dictionary modifies what will be saved to each file
	var save_dict := {
		"player_name" = PlayerAutoload.player_name,
	}
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string);
	var json = JSON.new()
	var err = json.parse(json_string);
	if err == OK:
		return true;
	else:
		return false;

func load_data(file_to_load : int):
	if not FileAccess.file_exists("user://save_file_"+str(file_to_load)+".save"):
		print("NullSaveError: no such file \"save_file"+str(file_to_load)+".save\" exists");
		return false;
	var save_file = FileAccess.open("user://save_file_"+str(file_to_load)+".save", FileAccess.READ);
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line();
		var json = JSON.new();
		var parse_result = json.parse(json_string);
		if not parse_result == OK:
			print("JSONError: exception while parsing file \"save_file"+str(file_to_load)+".save\"")
			print(json.get_error_message(), " in ", json_string, " at line ", json.get_error_line());
			return false;
		var data : Dictionary = json.data;
		#PlayerAutoload.name = data.get("player_name");
		return data
	return false;

func delete_data(file_to_delete : int):
	print("Deleting file \"save_file"+str(file_to_delete)+".save\"");
	DirAccess.remove_absolute("user://save_file_"+str(file_to_delete)+".save");
	
#loads and resets player autoload values, called in the main menu script
func player_autload_reset():
	PlayerAutoload.player_name = load_data(current_file).get("player_name");
	PlayerAutoload.current_block = BattleAutoload.location_types.NONE
	PlayerAutoload.current_combo = null
	PlayerAutoload.attack_history.resize(0)
	PlayerAutoload.attack_resources_in.clear()
	PlayerAutoload.attacks_per_turn = 2
	
	
	
	
