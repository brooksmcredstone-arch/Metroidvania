@tool
@icon("res://metroidvania_project/general/icons/breakable.svg")
class_name Breakable extends Node2D

signal destroyed
signal damage_taken

@export var hp : float = 3
@export var fixed_hit_count : bool = false

@export_category("Particles")
@export var emission_offset : Vector2 = Vector2.ZERO
@export var hit_particles : Array[HitParticleSettings]
@export var destroy_particles : Array[HitParticleSettings]

@export_category("Audio")
@export var hit_audio : AudioStream = preload("uid://8lo4rs1ksnsb")
@export var destroy_audio : AudioStream = preload("uid://cscql7cfck1r4")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for c in get_children():
		if c is DamageArea:
			c.damage_taken.connect(on_damage_taken)
	pass


func on_damage_taken(attack_area : AttackArea) -> void:
	if fixed_hit_count:
		hp -=1
	else:
		hp -= attack_area.damage
	
	var pos : Vector2 = global_position + emission_offset
	var dir : Vector2 = Vector2(1,-1)
	if attack_area.global_position.x > global_position.x:
		dir *= -1
	
	if hp > 0:
		damage_taken.emit()
		Audio.play_spatial_sound(hit_audio, pos)
		for p in hit_particles:
			VisualEffects.hit_particles(pos,dir,p)
	else:
		destroyed.emit()
		Audio.play_spatial_sound(destroy_audio, pos)
		for p in destroy_particles:
			VisualEffects.hit_particles(pos,dir,p)
		clear_collisions()
		destroyed.emit()
		var tween : Tween = create_tween()
		tween.tween_property(self, "modulate", Color(modulate, 0), 0.4)
		await tween.finished
		queue_free()
	pass



func clear_collisions() -> void:
	for c in get_children():
		if c is StaticBody2D:
			queue_free()
	pass



func _get_configuration_warnings() -> PackedStringArray:
	if check_for_damage_area() == false:
		return ["Requres a DamageArea Node"]
	else:
		return []


func check_for_damage_area() -> bool:
	for c in get_children():
		if c is DamageArea:
			return true
	return false
