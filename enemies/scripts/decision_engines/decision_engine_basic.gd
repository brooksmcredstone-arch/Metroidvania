class_name DecisionEngineBasic extends DecisionEngine

# Included in DecisionEngine:
# var enemy : Enemy
# var current_state : EnemyState
# var blackboard : Blackboard
@onready var es_walk: ESWalk = %ESWalk
@onready var es_death: ESDeath = %ESDeath
@onready var es_hurt: ESHurt = %ESHurt

func _ready( ) -> void: 
	await super() # Maintains important setup code and timing
	# Add code here :>
	pass



# All the conditions for decision making for the script goes here
func decide() -> EnemyState:
	if blackboard.damage_source:
		if blackboard.health <= 0:
			return es_death
		else:
			return es_hurt
	
	if current_state is ESDeath or not blackboard.can_decide:
		return null
	if blackboard.edge_detected:
		enemy.change_dir(-blackboard.dir)
	return es_walk
