extends Control

@export var levels: Array[PackedScene] = []

@onready var level_grid: GridContainer = $CenterContainer/VBoxContainer/LevelGrid
@onready var back_button: Button = $CenterContainer/VBoxContainer/BackButton

func _ready() -> void:
	for index in range(levels.size()):
		var level_scene: PackedScene = levels[index]
		var button := Button.new()
		
		button.text = str(index + 1)
		button.custom_minimum_size = Vector2(80, 40)
		button.disabled = level_scene == null
		button.pressed.connect(_on_level_pressed.bind(level_scene))
		
		level_grid.add_child(button)
	back_button.pressed.connect(_on_back_pressed)
	
	if not MenuMusic.playing:
		MenuMusic.play()

func _on_level_pressed(level_scene: PackedScene) -> void:
	Global.selected_level = level_scene
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")
