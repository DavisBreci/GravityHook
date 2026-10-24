extends Control

@export var levels: Array[PackedScene] = []

@onready var level_grid: GridContainer = $CenterContainer/VBoxContainer/LevelGrid
@onready var back_button: Button = $CenterContainer/VBoxContainer/BackButton

func _ready() -> void:
	Global.level_list.clear()
	for level_scene in levels:
		if level_scene != null:
			Global.level_list.append(level_scene)
			
	for index in range(levels.size()):
		var level_scene: PackedScene = levels[index]
		var button := Button.new()
		
		var best := Global.get_best_time(level_scene)
		button.text = str(index + 1)
		if best >= 0.0:
			button.text += "\n%.1f s" % best
		button.custom_minimum_size = Vector2(80, 44)
		button.add_theme_font_size_override("font_size", 12)
		button.disabled = level_scene == null
		button.pressed.connect(_on_level_pressed.bind(level_scene))
		
		level_grid.add_child(button)
	back_button.pressed.connect(_on_back_pressed)
	
	if not MenuMusic.playing:
		MenuMusic.play()
	level_grid.get_child(0).grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_pressed("back_in_menu"):
		_on_back_pressed()

func _on_level_pressed(level_scene: PackedScene) -> void:
	Global.selected_level = level_scene
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/title.tscn")
