class_name PlayerStateGroundSlam extends PlayerState

const DASH_AUDIO = preload("uid://dnuhpeb8ua8dm")
const BOOM_AUDIO = preload("uid://c8gkysjkgfy75")
const BREAK_WOOD_AUDIO = preload("uid://cscql7cfck1r4")

const HIT_WOOD_LARGE = preload("uid://pspplqokwij0")
const HIT_WOOD_MEDIUM = preload("uid://ddy2lu7atn2hp")
const HIT_WOOD_SMALL = preload("uid://cq2u8uieib3bf")



@export var velocity : float = 600
@export var effect_delay : float = 0.075
var effect_time : float = 0

@onready var damage_area: DamageArea = %DamageArea
@onready var ground_slam_shape_cast: ShapeCast2D = %GroundSlamShapeCast
@onready var ground_slam_attack_area: AttackArea = %GroundSlamAttackArea

func init() -> void:
	
	pass

# What the state the player enters as
func enter() -> void:
	player.animation_player.play("ground_slam")
	player.sprite.tween_color()
	Audio.play_spatial_sound(DASH_AUDIO,player.global_position)
	damage_area.start_invulnerability()
	ground_slam_attack_area.set_active()
	pass
	
# How the state exits as
func exit() -> void:
	VisualEffects.camera_shake(10.0)
	Audio.play_spatial_sound(BOOM_AUDIO, player.global_position)
	VisualEffects.land_dust(player.global_position)
	VisualEffects.hit_dust(player.global_position)
	damage_area.end_invulnerability()
	ground_slam_attack_area.set_active(false)
	pass

func handle_input(_event : InputEvent) -> PlayerState:
	
	return null
	
func process( _delta : float ) -> PlayerState:
	check_collisions(_delta)
	effect_time -= _delta
	if effect_time < 0:
		effect_time = effect_delay
		player.sprite.ghost()
	return null
	
func physics_process(_delta : float ) -> PlayerState:
	player.velocity.x = 0
	player.velocity = Vector2(0, velocity)
	if player.is_on_floor():
		if not check_collisions(_delta):
			return idle
	return next_state

func check_collisions(_delta : float) -> bool:
	ground_slam_shape_cast.target_position.y = velocity * _delta + 3
	ground_slam_shape_cast.force_shapecast_update()
	if ground_slam_shape_cast.is_colliding():
		for i in ground_slam_shape_cast.get_collision_count():
			var c  = ground_slam_shape_cast.get_collider(i)
			var pos : Vector2 = ground_slam_shape_cast.get_collision_point(i)
			
			VisualEffects.hit_dust(pos)
			VisualEffects.camera_shake(10.0)
			
			if c.get_parent() is Breakable:
				var b : Breakable = c.get_parent()
				b.queue_free()
				Audio.play_spatial_sound(b.destroy_audio,pos)
				for p in b.destroy_particles:
					VisualEffects.hit_particles(pos, Vector2.DOWN, p)
			else:
				c.queue_free()
				VisualEffects.hit_particles(pos, Vector2.DOWN, HIT_WOOD_SMALL)
				VisualEffects.hit_particles(pos, Vector2.DOWN, HIT_WOOD_MEDIUM)
				VisualEffects.hit_particles(pos, Vector2.DOWN, HIT_WOOD_LARGE)
				Audio.play_spatial_sound(BREAK_WOOD_AUDIO,pos)
			
			
		return true
	return false
