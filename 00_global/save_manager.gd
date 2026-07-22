#Save_Manager Script
extends Node

const CONFIG_FILE_PATH = "user://settings.cfg "
const SLOTS : Array[String] = [
	"save_01", "save_02", "save_03"
]

var current_slot : int = 0
var save_data : Dictionary
var discovered_areas : Array = []
var persistent_data : Dictionary = {}

func _ready() -> void:
	load_configuration()
	SceneManager.scene_entered.connect(_on_scene_entered)
	pass
 
func _unhandled_input(event: InputEvent)-> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P:
			save_game()
		elif event.keycode == KEY_O:
			load_game(current_slot)
		elif event.keycode == KEY_1:
			current_slot = 0
		elif event.keycode == KEY_2:
			current_slot = 1
		elif event.keycode == KEY_3:
			current_slot = 2
	pass

func create_new_game_save(slot : int) -> void:
	current_slot = slot
	discovered_areas.clear()
	persistent_data.clear()
	var new_game_scene: String = "uid://545uvo36q808"
	discovered_areas.append(new_game_scene)
	save_data = {
		"scene_path" : new_game_scene,
		"x" : 37,
		"y" : 232,
		"hp" : 20,
		"max_hp" : 20,
		"mp" : 20,
		"max_mp" : 20,
		"lvl" : 1,
		"atk" : 1,
		"mag" : 1,
		"def" : 0,
		"mdef" : 0,
		"experience" : 0,
		"gold" : 00,
		"dash" : false,
		"double_jump" : false,
		"ground_pound" : false,
		"floatation" : false,
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
	}
	## Save Data
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	
	save_file.close()
	
	load_game(slot)
	pass


func save_game() -> void:
	print("game saved")
	var player : Player = get_tree().get_first_node_in_group("Player")
	save_data = {
		"scene_path" : SceneManager.current_scene_uid,
		"x" : player.global_position.x,
		"y" : player.global_position.y,
		"hp" : player.hp,
		"max_hp" : player.max_hp,
		"mp" : player.mp,
		"max_mp" : player.max_mp,
		"lvl" : player.lvl,
		"atk" : player.atk,
		"mag" : player.mag,
		"def" : player.def,
		"mdef" : player.mdef,
		"experience" : player.experience,
		"gold" : player.gold,
		"dash" : player.dash,
		"double_jump" : player.double_jump,
		"ground_slam" : player.ground_slam,
		"glide" : player.glide,
		"discovered_areas" : discovered_areas,
		"persistent_data" : persistent_data,
	}
	## Save Data
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	pass
 

func load_game(slot : int) -> void:
	if not FileAccess.file_exists(get_file_name(current_slot)):
		return
	current_slot = slot
	
	var save_file = FileAccess.open(get_file_name(current_slot), FileAccess.READ)
	save_data = JSON.parse_string(save_file.get_line() )
	
	persistent_data = save_data.get("persistent_data", {} )
	discovered_areas = save_data.get("discovered_areas", []  )
	var scene_path : String = save_data.get("scene_path", "uid://545uvo36q808")
	SceneManager.transition_to_scene(scene_path, "", Vector2.ZERO, "up")
	await SceneManager.new_scene_ready
	setup_player()
	pass

func setup_player() -> void:
	var player : Player = null
	while not player:
		player = get_tree().get_first_node_in_group("Player")
		await get_tree().process_frame
	
	player.max_hp = save_data.get("max_hp", 20)
	player.hp = save_data.get("hp", 20)
	player.max_mp = save_data.get("max-mp", 20)
	player.mp = save_data.get("mp", 20)
	player.lvl = save_data.get("lvl", 1)
	player.experience = save_data.get("experience", 0)
	player.atk = save_data.get("atk", 1)
	player.mag = save_data.get("mag",1)
	player.def = save_data.get("def",1)
	player.mdef = save_data.get("mdef",1)
	player.dash = save_data.get("dash", false)
	player.double_jump = save_data.get("double_jump", false)
	player.ground_slam = save_data.get("ground_slam", false)
	player.glide = save_data.get("glide", false)
	
	player.global_position = Vector2(
		save_data.get("x", 0), 
		save_data.get("y", 0)
		)
	pass

func get_file_name(slot : int) -> String:
	return "user://" + SLOTS[slot] + ".sav"

func _save_slot_exists(slot : int) -> bool:
	return FileAccess.file_exists(get_file_name(slot))

func _is_area_discovered(scene_uid : String) -> bool:
	return discovered_areas.has(scene_uid)

func _on_scene_entered(scene_uid : String) -> void:
	if discovered_areas.has(scene_uid):
		return
	else:
		discovered_areas.append(scene_uid)
	pass

#region /// Save Configurations

func save_configuration() -> void:
	var config := ConfigFile.new()
	config.set_value("audio","music", AudioServer.get_bus_volume_linear(2))
	config.set_value("audio","sfx", AudioServer.get_bus_volume_linear(3))
	config.set_value("audio","ui", AudioServer.get_bus_volume_linear(4))
	config.save(CONFIG_FILE_PATH)
	pass


func load_configuration() -> void:
	var config := ConfigFile.new()
	var err = config.load(CONFIG_FILE_PATH)
	
	if err != OK:
		AudioServer.set_bus_volume_linear(2, 0.5)
		AudioServer.set_bus_volume_linear(3, 1)
		AudioServer.set_bus_volume_linear(4, 1)
		return

	AudioServer.set_bus_volume_linear(2, config.get_value("audio", "music", 0.5))
	AudioServer.set_bus_volume_linear(3, config.get_value("audio", "sfx", 1))
	AudioServer.set_bus_volume_linear(4, config.get_value("audio", "ui", 1))
	pass

#endregion
