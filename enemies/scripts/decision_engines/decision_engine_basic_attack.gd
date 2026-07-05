class_name DecisionEngineBasicAttack extends DecisionEngine


@onready var es_walk: ESWalk = %ESWalk
@onready var es_death: ESDeath = %ESDeath
@onready var es_hurt: ESHurt = %ESHurt

@export var attack_state : ESAttack
@export var chase_state : EnemyState

func _ready( ) -> void: 
	await super()
	pass




func decide() -> EnemyState:
	if blackboard.damage_source:
		if blackboard.health <=0:
			return es_death
		else:
			return es_hurt
	if current_state is ESDeath or not blackboard.can_decide:
		return null
		
	if blackboard.target:
		if attack_state.can_attack():
			return attack_state
		return chase_state
	return es_walk
