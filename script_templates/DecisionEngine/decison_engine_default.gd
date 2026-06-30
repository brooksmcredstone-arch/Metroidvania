#class_name DecisionEngineName
extends DecisionEngine
# meta-name DecisionEngine
# boilerplate decision engine script
# meta-default : True

# Included in DecisionEngine:
# var enemy : Enemy
# var current_state : EnemyState
# var blackboard : Blackboard


func _ready( ) -> void: 
	await super() # Maintains important setup code and timing
	# Add code here :>
	pass



# All the conditions for decision making for the script goes here
func decide() -> EnemyState:
	# Example Decision Script
	#if blackboard.damage_source:
		#if blackboard.health <0:
			#return es_death
		#else:
			#return es_hurt
	# if current_state is  ESDeath or not blackboard.can_decide:
		# return null
	
	#if  blackboard.target:
		#if blackboard.distance_to_target < 40:
			#return attack_state
		#return chase_state
	return null
