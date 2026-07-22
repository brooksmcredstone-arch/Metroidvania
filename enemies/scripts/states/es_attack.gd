class_name ESAttack extends EnemyState

@export var attack_area : AttackArea
@export var attack_range : float = 100
@export var move_speed : float = 100
@export var cooldown : float = 3.0
@export var move_speed_curve : Curve

var timer : float = 0
var duration : float = 0
var on_cooldown : bool = false
var dir : Vector2
var sample : float = 1.0


func enter() -> void:
	enemy.play_animation(animation_name if animation_name else "attack")
	duration = enemy.animation.current_animation_length
	timer = 0
	blackboard.can_decide = false
	on_cooldown = true
	enemy.velocity.x = move_speed * blackboard.dir
	if attack_area:
		attack_area.atk = enemy.get_attack_power(attack_area.damage_type)
		attack_area.flip(blackboard.dir)
	pass


func re_enter() -> void:
	on_cooldown = false
	enemy.play_animation(animation_name if animation_name else "attack")
	duration = enemy.animation.current_animation_length
	timer = 0
	blackboard.can_decide = false
	on_cooldown = true
	enemy.velocity.x = move_speed * blackboard.dir
	if attack_area:
		attack_area.atk = enemy.get_attack_power(attack_area.damage_type)
		attack_area.flip(blackboard.dir)
	pass


func exit() -> void:
	timer = 0 
	blackboard.can_decide = true
	run_cooldown()
	pass


func physics_update(delta : float) -> void:
	timer += delta
	if timer >= duration:
		blackboard.can_decide = true
	if move_speed_curve:
		sample  = move_speed_curve.sample(timer/duration)
	if blackboard.target == null:
		return
	elif blackboard.target != null:
		dir = enemy.global_position.direction_to(blackboard.target.global_position)
		enemy.change_dir(sign(dir.x))
		enemy.velocity.x = move_speed * sample * blackboard.dir
	pass


func can_attack() -> bool:
	if blackboard.distance_to_target <= attack_range and not on_cooldown:
		return true
	return false


func run_cooldown() -> void:
	await get_tree().create_timer(cooldown).timeout
	on_cooldown = false
	pass
