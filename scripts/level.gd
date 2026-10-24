extends Node2D
var layout: Node2D
const SPAWN = Vector2(100,260)
const STARTING_GRAVITY = Vector2(0,1)
var finish_time: float = 0.0
var best_time: float = -1.0
var level_finished: bool = false

func _enter_tree() -> void:
	MenuMusic.stop()
	LevelMusic.stream_paused = false
	if not LevelMusic.playing:
		LevelMusic.play()
	
	layout = Global.selected_level.instantiate()
	$LevelLayout.add_child(layout)


func _exit_tree() -> void:
	LevelMusic.stop()

func _ready() -> void:
	reset_level()
	$LevelComplete.exit_requested.connect(_on_completion_exit)
	$LevelComplete.replay_requested.connect(_on_completion_replay)
	$LevelComplete.continue_requested.connect(_on_completion_continue)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_level() -> void:
	$Player.velocity = Vector2.ZERO
	$Player.physics_velocity = Vector2.ZERO
	$Player.position = SPAWN
	$Player.freeze = false
	$Player.set_gravity(STARTING_GRAVITY, false)
	layout.get_node("coin").reset_coin()
	$Clock.reset_clock()

func _on_player_gravity_change(new_gravity: Vector2) -> void:
	get_tree().paused = true
	await get_tree().create_timer(0.1).timeout
	
	if not $PauseMenu.is_open():
		get_tree().paused = false

func _on_player_death() -> void:
	reset_level()

func _on_player_level_complete() -> void:
	if level_finished:
		return
	level_finished = true
	finish_time = $Clock.stop_clock()
	best_time = Global.record_time(Global.selected_level, finish_time)
	$PauseMenu.set_process_input(false)
	LevelMusic.stop()
	$VictorySound.play()
	$CanvasLayer/ColorRect.target = $Player

func _on_color_rect_animation_complete() -> void:
	var has_next_level := _get_next_level() != null
	if Global.auto_level_prog:
		if has_next_level:
			_on_completion_continue()
		else:
			_on_completion_exit()
	else:
		$LevelComplete.show_results(
			finish_time,
			best_time,
			has_next_level
		)

func _get_next_level() -> PackedScene:
	var current_index := Global.level_list.find(Global.selected_level)
	if current_index < 0:
		return null
	var next_index := current_index + 1
	if next_index >= Global.level_list.size():
		return null
	return Global.level_list[next_index]

func _on_completion_exit() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_completion_replay() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_completion_continue() -> void:
	var next_level := _get_next_level()
	if next_level == null:
		return
	Global.selected_level = next_level
	get_tree().paused = false
	get_tree().reload_current_scene()
