#class_name ESName
extends EnemyState
# meta-name: EnemyState
# meta-description: Boilerplate template for the state script
# meta-default: true

#EnemyState classs will inhaerit the following variables:
# @export var animation_name : String = :idle
# var state_machine : EnemyStateMachine
# var enemy : Enemy
# var blackboard : Blackboard

func enter() -> void:
	# what happens when we enter his state?
	pass
func re_enter() -> void:
	# what happens when we re-enter the state?
	pass
func exit() -> void:
	# what happens when we exit this state?
	pass
func physics_update(_delta : float) -> void:
	# What physics are being updated here?
	pass
