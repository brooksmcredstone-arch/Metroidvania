class_name PlayerCamera extends Camera2D

var shake_strengh : float = 0.0
@export var shake_decay_rate : float = 5.0
@export var max_shake_offset : float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	VisualEffects.camera_shook.connect(_apply_shake)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset = Vector2(
			randf_range(-shake_strengh,shake_strengh),
			randf_range(-shake_strengh,shake_strengh)
		)
	shake_strengh = lerp(shake_strengh, 0.0, shake_decay_rate * delta)
	pass



func _apply_shake(strength : float) -> void:
	shake_strengh = min(strength, max_shake_offset)
	pass
