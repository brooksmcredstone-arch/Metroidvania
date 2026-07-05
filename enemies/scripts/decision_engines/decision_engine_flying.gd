class_name DecisionEngineFlying extends DecisionEngine

@export var idle_state : EnemyState
@export var fly_state : EnemyState
@export var chase_state : EnemyState
@export var attack_state : EnemyState
@export var death_state : EnemyState
@export var hurt_state : EnemyState


func _ready( ) -> void: 
	await super() # Maintains important setup code and timing
	# Add code here :>
	pass



# All the conditions for decision making for the script goes here
func decide() -> EnemyState:
	if blackboard.damage_source:
		if blackboard.health <=0:
			return death_state
		else:
			return hurt_state
	if current_state is  ESDeath or not blackboard.can_decide:
		return null
	
	if blackboard.target:
		if attack_state.can_attack():
			return attack_state
		return chase_state
	return fly_state
