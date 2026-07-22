@abstract
class_name Pickup extends CharacterBody2D

@export var pickup_audio : AudioStream
@export var bounciness : float = 0.5
@export var bounce_count : int = 8

var area_2d : Area2D

func _ready() -> void:
	for c in get_children():
		if c is Area2D:
			area_2d = c
			area_2d.body_entered.connect(_on_player_entered)
	pass

func _physics_process(delta: float) -> void:
	if bounce_count > 0:
		velocity += get_gravity() * delta
		var collision : KinematicCollision2D = move_and_collide(velocity * delta)
		if collision:
			bounce_count -= 1
			velocity = velocity.bounce(collision.get_normal()) * bounciness
			velocity.x *= bounciness
	pass

func _on_player_entered(n : Node) -> void:
	if n is Player:
		on_pickup(n)
		area_2d.body_entered.disconnect(_on_player_entered)
		Audio.play_spatial_sound(pickup_audio, global_position)
		queue_free()
	pass

@abstract func on_pickup(player : Player) 
	
