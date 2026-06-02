class_name PlayerState extends Node


var player : Player
var next_state : PlayerState

#region state references
# references all states
@onready var idle = %Idle
@onready var run = %Run
@onready var jump = %Jump
@onready var fall = %Fall
@onready var crouch = %Crouch



#endregion
	
# Initializes the states
func init() -> void:
	
	pass

# What the state the player enters as
func enter() -> void:
	
	pass
	
# How the state exits as
func exit() -> void:
	
	pass
	

func handle_input(_event : InputEvent) -> PlayerState:
	
	return next_state
	
func process( _delta : float ) -> PlayerState:
	
	return next_state
	
func physics_process(_delta : float ) -> PlayerState:
	
	return next_state
