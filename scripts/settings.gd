extends Control

@export
var master_slider: HSlider
var master_bus_index: int

@export
var music_slider: HSlider
var music_bus_index: int

@export
var sfx_slider: HSlider
var sfx_bus_index: int

@export
var auto_check: CheckBox

@export
var quit_title: Button

@export
var quit_game: Button


func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Mast$MarginContainer/VBoxContainer/HBoxContainer/QuitGameer")
	master_slider.value_changed.connect(_on_master_value_changed)
	
	music_bus_index = AudioServer.get_bus_index("Music")
	music_slider.value_changed.connect(_on_music_value_changed)
	
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	sfx_slider.value_changed.connect(_on_sfx_value_changed)
	
	auto_check.toggled.connect(_on_auto_toggled)
	
	quit_title.pressed.connect(_on_quit_title_pressed)
	
	quit_game.pressed.connect(_on_quit_game_pressed)
	
func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		master_bus_index,
		linear_to_db(value)
	)
	
func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		music_bus_index,
		linear_to_db(value)
	)
	
func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		sfx_bus_index,
		linear_to_db(value)
	)

func _on_auto_toggled(toggled_on: bool):
	Global.auto_level_prog = toggled_on

func _on_quit_title_pressed():
	pass
	
func _on_quit_game_pressed():
	get_tree().quit()
