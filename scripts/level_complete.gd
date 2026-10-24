extends CanvasLayer

signal exit_requested
signal replay_requested
signal continue_requested

@onready var overlay: Control = $Overlay
@onready var content: VBoxContainer = $Overlay/CenterContainer/PanelContainer/VBoxContainer

@onready var time_label: Label = content.get_node("TimeLabel")
@onready var best_label: Label = content.get_node("BestLabel")

@onready var exit_button: Button = content.get_node("ExitButton")
@onready var replay_button: Button = content.get_node("ReplayButton")
@onready var continue_button: Button = content.get_node("ContinueButton")

func _ready() -> void:
	overlay.hide()
	exit_button.pressed.connect(_on_exit_pressed)
	replay_button.pressed.connect(_on_replay_pressed)
	continue_button.pressed.connect(_on_continue_pressed)

func show_results(finish_time: float, best_time: float, has_next_level: bool) -> void:
	time_label.text = "Time: %.2f s" % finish_time
	best_label.text = "Best: %.2f s" % best_time
	continue_button.visible = has_next_level
	overlay.show()
	get_tree().paused = true
	if has_next_level:
		continue_button.grab_focus()
	else:
		replay_button.grab_focus()

func _on_exit_pressed() -> void:
	exit_requested.emit()

func _on_replay_pressed() -> void:
	replay_requested.emit()

func _on_continue_pressed() -> void:
	continue_requested.emit()
