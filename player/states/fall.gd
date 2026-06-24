class_name PlayerStateFall extends PlayerState

@export var fall_gravity_multplier : float = 1.165
@export var coyote_time : float = 0.125
@export var jump_buffer_time : float = 0.2

@onready var land_audio: AudioStreamPlayer2D = %LandAudio


var coyote_timer : float = 0
var buffer_timer : float = 0
# Initializes the states
func init() -> void:
	pass

# What the state the player enters as
func enter() -> void:
	player.animation_player.play("jump")
	player.animation_player.pause()
	player.gravity_multiplier = fall_gravity_multplier
	
	if player.jump_count == 0:
		player.jump_count = 1
	
	var prev : PlayerState = player.previous_state
	if prev == jump or prev == attack or prev == dash:
		coyote_timer = 0
	elif player.previous_state == crouch:
		coyote_time = 0
		player.jump_count = 1
	else:
		coyote_timer = coyote_time
	pass
	
# How the state exits as
func exit() -> void:
	player.gravity_multiplier = 1.0
	buffer_timer = 0
	pass
	

func handle_input(event : InputEvent) -> PlayerState:
	if event.is_action_pressed("dash") and player.can_dash():
		return dash
	if event.is_action_pressed("attack"):
		if player.ground_slam and Input.is_action_pressed("down"):
			return ground_slam
		return attack
	if event.is_action_pressed("jump"):
		if coyote_timer > 0:
			player.jump_count = 0
			return jump
		elif  player.jump_count <= 1 and player.double_jump:
			return jump
		else:
			buffer_timer = jump_buffer_time
	return next_state
	
func process( delta : float ) -> PlayerState:
	coyote_timer -= delta
	buffer_timer -= delta
	set_jump_frame()
	return next_state
	
func physics_process(_delta : float ) -> PlayerState:
	if player.is_on_floor():
		VisualEffects.land_dust(player.global_position)
		land_audio.play()
		if buffer_timer > 0:
			player.jump_count = 0
			return jump
		return idle
	player.velocity.x = player.direction.x * player.move_speed
	return next_state

func set_jump_frame() -> void:
	var frame : float = remap(player.velocity.y, 0.0, player.max_fall_velocity, 0.5, 1.0)
	player.animation_player.seek(frame, true)
	pass
