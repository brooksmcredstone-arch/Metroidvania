class_name PlayerStateIdle extends PlayerState


func init() -> void:
	
	pass

# What the state the player enters as
func enter() -> void:
	player.animation_player.play("idle")
	pass
	
# How the state exits as
func exit() -> void:
	
	pass

func handle_input(event : InputEvent) -> PlayerState:
	if event.is_action_pressed("jump"):
		return jump
	return next_state
	
func process( _delta : float ) -> PlayerState:
	if player.direction.x != 0:
		return run
	elif player.direction.y > 0.5:
		return crouch
	return next_state
	
func physics_process(_delta : float ) -> PlayerState:
	player.velocity.x = 0
	if player.is_on_floor() == false:
		return fall
	return next_state
