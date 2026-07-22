class_name ItemPickup extends Area2D

@export var item_data : ItemData
@onready var sprite_2d: Sprite2D = $Sprite2D

@export_category("Audio")
@export var pickup_audio : AudioStream

func _ready() -> void:
	if item_data:
		sprite_2d.texture = item_data.texture
	else:
		push_warning("ItemPickup spawned without texture")
	
	body_entered.connect(_on_body_entered)
	pass 


func _on_body_entered(body : Node2D) -> void:
	if body.is_in_group("Player"):
		InventoryManager.add_item(item_data)
		Audio.play_spatial_sound(pickup_audio,global_position)
		queue_free()
	pass
