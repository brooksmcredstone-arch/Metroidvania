#Player HUD
extends CanvasLayer

@onready var hp_margin_container : MarginContainer = %HPMarginContainer
@onready var hp_bar : TextureProgressBar = %HPBar

@onready var game_over: Control = %GameOver
@onready var load_button: Button = %LoadButton
@onready var quit_button: Button = %QuitButton
@onready var gold_amount_label: Label = $Control/HBoxContainer/GoldAmountLabel


func _ready() -> void:
	#connect to message bus system
	Messages.player_health_changed.connect(_update_hp_bar)
	Messages.gold_collected.connect(_on_gold_changed)
	game_over.visible = false
	load_button.pressed.connect(_on_load_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	pass

func _update_hp_bar(hp : float, max_hp : float) -> void:
	var value : float = (hp/max_hp) * 100
	hp_bar.value = value
	hp_margin_container.size.x = max_hp + 22
	pass

func _on_gold_changed(amount : int) -> void:
	gold_amount_label.text = str(amount)
	pass

func show_game_over() -> void:
	load_button.visible = false
	quit_button.visible = false
	
	game_over.modulate.a = 0
	game_over.visible = true
	
	var tween : Tween = create_tween()
	tween.tween_property(game_over, "modulate",Color.WHITE, 3.0)
	await tween.finished
	
	load_button.visible = true
	quit_button.visible = true
	
	load_button.grab_focus()
	
	pass

func clear_game_over() -> void:
	load_button.visible = false
	quit_button.visible = false
	await SceneManager.scene_entered
	game_over.visible = false
	var player : Player = get_tree().get_first_node_in_group("Player")
	player.queue_free()
	pass

func _on_load_pressed() -> void:
	SaveManager.load_game(SaveManager.current_slot)
	clear_game_over()
	pass

func _on_quit_pressed() -> void:
	SceneManager.transition_to_scene("res://metroidvania_project/title_screen/title_screen.tscn", "", Vector2.ZERO, "up" )
	clear_game_over()
	pass
