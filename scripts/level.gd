extends Node2D
const SPAWN = Vector2(100,260)
const STARTING_GRAVITY = Vector2(0,1)
var best_time = -1.0

func _enter_tree() -> void:
	MenuMusic.stop()
	
	var layout = Global.selected_level.instantiate()
	$LevelLayout.add_child(layout)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_position() -> void:
	$Player.velocity = Vector2.ZERO
	$Player.physics_velocity = Vector2.ZERO
	$Player.position = SPAWN
	$Player.freeze = false
	$Player.set_gravity(STARTING_GRAVITY, false)
	

func _on_player_gravity_change(new_gravity: Vector2) -> void:
	get_tree().paused = true
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false

func _on_player_death() -> void:
	reset_position()

func _on_player_level_complete() -> void:
	#record best time
	if best_time == -1.0 or $Clock.time < best_time:
		best_time = $Clock.time
	#play animations
	$CanvasLayer/ColorRect.target = $Player

func _on_color_rect_animation_complete() -> void:
	$CanvasLayer/ColorRect.reset_shader()
	reset_position()
