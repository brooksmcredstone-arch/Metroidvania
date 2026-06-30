@icon("res://metroidvania_project/general/icons/enemy_hit_particles.svg")
class_name EnemyHitParticles extends Marker2D

@export var hit_paricles : Array[HitParticleSettings]
@export var death_particles : Array[HitParticleSettings]

var enemy_was_killed : bool = false


func _ready() -> void:
	if owner is Enemy:
		owner.was_hit.connect(_on_hit)
		owner.was_killed.connect(_on_killed)
	else:
		for c in get_parent().get_children():
			if  c is DamageArea:
				c.damage_taken.connect(_on_hit)
	pass

func _on_hit(a : AttackArea) -> void:
	var dir : Vector2 = global_position.direction_to(a.global_position)
	dir.x *= -1
	var particles = hit_paricles
	if enemy_was_killed:
		particles = death_particles
	
	for p in particles:
		VisualEffects.hit_particles(global_position, dir, p)
	pass

func _on_killed() -> void:
	enemy_was_killed = true
	pass
