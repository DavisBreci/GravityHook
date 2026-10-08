extends Node2D
const SPAWN = Vector2(100,100)
const STARTING_GRAVITY = Vector2(0,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D/ArrowTexture.modulate.a = 0.5
	$Sprite2D/ArrowTexture.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_position() -> void:
	$Player.velocity = Vector2.ZERO
	$Player.physics_velocity = Vector2.ZERO
	$Player.position = SPAWN
	$Player.set_gravity(STARTING_GRAVITY)

func _on_player_gravity_change(new_gravity: Vector2) -> void:
	get_tree().paused = true
	$Player/AnimatedSprite2D.rotation = atan2(new_gravity.y, new_gravity.x) - PI/2
	$Sprite2D/ArrowTexture.rotation = atan2(new_gravity.y, new_gravity.x) + PI/2
	$Sprite2D/ArrowTexture.show()
	await get_tree().create_timer(0.1).timeout
	$Sprite2D/ArrowTexture.hide()
	get_tree().paused = false
	


func _on_player_death() -> void:
	reset_position()


func _on_player_level_complete() -> void:
	#play animations
	#record best time
	#load new level
	reset_position()
