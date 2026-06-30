class_name ESWalk extends EnemyState

@export var walk_speed : float = 50.0


func enter() -> void:
	var anim : String = animation_name if animation_name else "walk"
	enemy.play_animation(anim)
	pass
func re_enter() -> void:
	# what happens when we re-enter the state?
	pass
func exit() -> void:
	# what happens when we exit this state?
	pass
func physics_update(_delta : float) -> void:
	if enemy.is_on_wall():
		enemy.change_dir(-blackboard.dir)
	enemy.velocity.x = blackboard.dir * walk_speed
	pass
