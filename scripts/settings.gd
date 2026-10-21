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
var quit: Button

func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Master")
	master_slider.value_changed.connect(_on_master_value_changed)
	
	music_bus_index = AudioServer.get_bus_index("Music")
	music_slider.value_changed.connect(_on_music_value_changed)
	
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	sfx_slider.value_changed.connect(_on_sfx_value_changed)
	
	auto_check.toggled.connect(_on_auto_toggled)
	
	quit.pressed.connect(_on_quit_pressed)
	
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

func _on_quit_pressed():
	pass
