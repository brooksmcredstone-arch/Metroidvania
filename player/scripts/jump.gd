class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450

# Initializes the states
func init() -> void:
	
	pass

# What the state the player enters as
func enter() -> void:
	VisualEffects._jump_dust(player.global_position)
	player.animation_player.play("jump")
	player.animation_player.pause()
	player.velocity.y = -jump_velocity
	
	#buffer jump check. If buffer is true, then the jump happened before that
	if player.previous_state == fall and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame #
		player.velocity.y *= 0.5
		player.change_state(fall)
		pass 
	pass
	
# How the state exits as
func exit() -> void:
	
	pass
	

func handle_input(event : InputEvent) -> PlayerState:
	if event.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall
	return next_state
	
func process( _delta : float ) -> PlayerState:
	set_jump_frame()
	return next_state
	
func physics_process(_delta : float ) -> PlayerState:
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall
	player.velocity.x = player.direction.x * player.move_speed
	return next_state


func set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, -jump_velocity, 0.0, 0.0, 0.5)
	player.animation_player.seek(frame, true)
	pass
