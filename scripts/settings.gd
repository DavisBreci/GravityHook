extends Control

@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider
@export var auto_check: CheckBox
@export var quit_title: Button
@export var quit_game: Button

func _ready() -> void:
	if not MenuMusic.playing:
		MenuMusic.play()
	master_slider.set_value_no_signal(Global.volumes["Master"])
	master_slider.grab_focus()
	music_slider.set_value_no_signal(Global.volumes["Music"])
	sfx_slider.set_value_no_signal(Global.volumes["SFX"])
	auto_check.set_pressed_no_signal(Global.auto_level_prog)
	master_slider.value_changed.connect(_on_master_value_changed)
	music_slider.value_changed.connect(_on_music_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_value_changed)
	auto_check.toggled.connect(_on_auto_toggled)
	quit_title.pressed.connect(_on_quit_title_pressed)
	quit_game.pressed.connect(_on_quit_game_pressed)

func _process(delta: float) -> void:
	if Input.is_action_pressed("back_in_menu"):
		_on_quit_title_pressed()

func _on_master_value_changed(value: float) -> void:
	Global.set_volume("Master", value)

func _on_music_value_changed(value: float) -> void:
	Global.set_volume("Music", value)

func _on_sfx_value_changed(value: float) -> void:
	Global.set_volume("SFX", value)

func _on_auto_toggled(toggled_on: bool) -> void:
	Global.auto_level_prog = toggled_on
	Global.save_settings()

func _on_quit_title_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
