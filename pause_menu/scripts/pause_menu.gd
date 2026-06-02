#What happens when the game is paused
class_name PauseMenu extends CanvasLayer

#region //Interactive Elements for Pause Menu
@onready var pause_screen : Control = %PauseScreen
@onready var system_screen : Control = %SystemScreen

@onready var system : Button = %System

@onready var map : Button = %Map
@onready var title : Button = %Title
@onready var music_slider : HSlider = %MusicSlider
@onready var sfx_slider : HSlider = %SFXSlider
@onready var ui_slider : HSlider = %UISlider
#endregion

var player_pos : Vector2

func _ready()-> void:
	#grab player
	_show_pausescreen()
	system.pressed.connect(_show_system_menu)
	Audio.setup_button_audio(self)
	setup_system_menu()
	var player : Node2D = get_tree().get_first_node_in_group("Player")
	if player:
		player_pos = player.global_position
	pass


func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = false
		queue_free()
	if pause_screen.visible == true:
		if event.is_action_pressed("down") or event.is_action_pressed("right"):
			system.grab_focus()
	pass


func _show_pausescreen() -> void:
	pause_screen.visible = true
	system_screen.visible = false
	pass


func _show_system_menu() -> void:
	pause_screen.visible = false
	system_screen.visible = true
	map.grab_focus()
	pass


func setup_system_menu() -> void:
	music_slider.value = AudioServer.get_bus_volume_linear(2)
	sfx_slider.value = AudioServer.get_bus_volume_linear(3)
	ui_slider.value = AudioServer.get_bus_volume_linear(4)
	
	music_slider.value_changed.connect(_on_music_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	ui_slider.value_changed.connect(_on_ui_slider_changed)
	
	title.pressed.connect(_on_title_button_pressed)
	map.pressed.connect(_show_pausescreen)
	pass 


func _on_title_button_pressed() -> void:
	#free player
	SceneManager.transition_to_scene("res://metroidvania_project/title_screen/title_screen.tscn", "", Vector2.ZERO, "Up")
	get_tree().paused = false
	Messages.back_to_title_screen.emit()
	queue_free()
	pass


func _on_music_slider_changed(v : float) -> void:
	AudioServer.set_bus_volume_linear(2, v)
	SaveManager.save_configuration()
	
	pass


func _on_sfx_slider_changed(v : float) -> void:
	AudioServer.set_bus_volume_linear(3, v)
	Audio.play_spatial_sound(Audio.ui_focus_audio, player_pos)
	SaveManager.save_configuration()
	
	pass


func _on_ui_slider_changed(v : float) -> void:
	AudioServer.set_bus_volume_linear(3, v)
	SaveManager.save_configuration()
	pass
