class_name PlayerStateDeath extends PlayerState

const DEATH_AUDIO = preload("uid://c7foxmlx680v7")

# What the state the player enters as
func enter() -> void:
	player.animation_player.play("death")
	Audio.play_spatial_sound(DEATH_AUDIO, player.global_position)
	Audio.play_music(null)
	await player.animation_player.animation_finished
	PlayerHud.show_game_over()
	pass
	
# How the state exits as
func exit() -> void:
	
	pass

func handle_input(_event : InputEvent) -> PlayerState:
	
	return null
	
func process( _delta : float ) -> PlayerState:
	
	return null
	
func physics_process(_delta : float ) -> PlayerState:
	player.velocity.x = 0
	player.velocity.y = 0
	return null
