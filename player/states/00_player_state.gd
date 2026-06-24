@icon("res://metroidvania_project/player/states/state.svg")
class_name PlayerState extends Node

var player : Player
var next_state : PlayerState

#region state references
@onready var idle: PlayerStateIdle = %Idle
@onready var crouch: PlayerStateCrouch = %Crouch
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var attack: PlayerStateAttack = %Attack
@onready var hurt: PlayerHurtState = %Hurt
@onready var death: PlayerStateDeath = %Death
@onready var dash: PlayerStateDash = %Dash
@onready var ground_slam: PlayerStateGroundSlam = %GroundSlam

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
