extends CanvasLayer

@onready var overlay: Control = $Overlay
@onready var continue_button: Button = $Overlay/CenterContainer/PanelContainer/VBoxContainer/ContinueButton
@onready var exit_button: Button = $Overlay/CenterContainer/PanelContainer/VBoxContainer/ExitButton

func _ready() -> void:
	overlay.hide()
	continue_button.pressed.connect(_on_continue_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		get_viewport().set_input_as_handled()
		if is_open():
			_on_continue_pressed()
		else:
			open_menu()

func is_open() -> bool:
	return overlay.visible

func open_menu() -> void:
	overlay.show()
	get_tree().paused = true
	continue_button.grab_focus()
	LevelMusic.stream_paused = true

func _on_continue_pressed() -> void:
	overlay.hide()
	get_tree().paused = false
	LevelMusic.stream_paused = false

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
