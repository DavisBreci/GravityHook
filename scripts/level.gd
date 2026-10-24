extends Node2D
var layout: Node2D
const SPAWN = Vector2(100,260)
const STARTING_GRAVITY = Vector2(0,1)

func _enter_tree() -> void:
	MenuMusic.stop()
	LevelMusic.stream_paused = false
	if not LevelMusic.playing:
		LevelMusic.play()
	
	layout = Global.selected_level.instantiate()
	$LevelLayout.add_child(layout)


func _exit_tree() -> void:
	LevelMusic.stop()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_level()

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
	LevelMusic.stop()
	$VictorySound.play()
#TODO: update best time for the CURRENT level
	if layout.best_time == -1.0 or $Clock.time < layout.best_time:
		layout.best_time = $Clock.time
	#play animations
	$CanvasLayer/ColorRect.target = $Player
	$Clock.freeze = true

func _on_color_rect_animation_complete() -> void:
	$CanvasLayer/ColorRect.reset_shader()
	reset_level()
