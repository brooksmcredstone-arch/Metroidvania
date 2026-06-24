class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 450

@onready var jump_audio: AudioStreamPlayer2D = %JumpAudio


# Initializes the states
func init() -> void:
	
	pass

# What the state the player enters as
func enter() -> void:
	if player.is_on_floor():
		VisualEffects.jump_dust(player.global_position)
	else:
		VisualEffects.hit_dust(player.global_position)
	player.animation_player.play("jump")
	player.animation_player.pause()
	player.velocity.y = -jump_velocity
	jump_audio.play()
	#buffer jump check. If buffer is true, then the jump happened before that\\
	
	do_jump()
	
	if player.previous_state == fall and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame #
		player.velocity.y *= 0.5
		player.change_state(fall)
		pass 
	pass

func do_jump() -> void:
	if player.jump_count > 0:
		if player.double_jump == false:
			return
		elif player.jump_count > 1:
			return
	player.jump_count += 1
	player.velocity.y = -jump_velocity
	jump_audio.play()
	pass

# How the state exits as
func exit() -> void:
	
	pass
	

func handle_input(event : InputEvent) -> PlayerState:
	if event.is_action_pressed("dash") and player.can_dash():
		return dash
	if event.is_action_pressed("attack"):
		if player.ground_slam and Input.is_action_pressed("down"):
			return ground_slam
		return attack
	if event.is_action_released("jump"):
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
