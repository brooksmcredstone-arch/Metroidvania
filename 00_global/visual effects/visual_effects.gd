# Visual Effects
extends Node

const DUST_EFFECT = preload("uid://cs6clkw0a5ag8")
const HIT_PARTICLES = preload("uid://c06uagl8vgjy1")

signal camera_shook(strength : float)


# Create Effects
# Create New Instance of Dust Effects
func create_dust_effects(pos : Vector2) -> DustEffect:
	var dust : DustEffect = DUST_EFFECT.instantiate()
	add_child(dust)
	dust.global_position = pos
	return dust


# Create Jump Dust
func jump_dust(pos : Vector2) ->void:
	var dust : DustEffect = create_dust_effects(pos)
	dust.start(DustEffect.TYPE.JUMP)
	pass
	
# Create Land Dust
func land_dust(pos : Vector2) ->void:
	var dust : DustEffect = create_dust_effects(pos)
	dust.start(DustEffect.TYPE.LAND)
	pass
	
# Create Hit Dust
func hit_dust(pos : Vector2) ->void:
	var dust : DustEffect = create_dust_effects(pos)
	dust.start(DustEffect.TYPE.HIT)
	pass


func hit_particles(pos : Vector2, dir : Vector2, settings : HitParticleSettings) -> void:
	var p : HitParticles = HIT_PARTICLES.instantiate()
	add_child(p)
	p.global_position = pos
	p.start(dir, settings)
	pass
	
	
func camera_shake(strength : float = 1.0) -> void:
	camera_shook.emit(strength)
	pass
