@icon("res://metroidvania_project/general/icons/player_spawn.svg")
class_name PlayerSpawn extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	await get_tree().process_frame
	
	# Check for Player in Scene, and if not present, spawn them in the scene
	if get_tree().get_first_node_in_group("Player"):
		print("Player found!")
		return
	
	print("Player not found!")
	# Instantiate a new instance of our player scene
	var player : Player = load("uid://dd0te187ig2kn").instantiate()
	get_tree().root.add_child(player)
	#Position the player into the world
	player.global_position = self.global_position
	pass 
