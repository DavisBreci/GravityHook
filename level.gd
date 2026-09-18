extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D/ArrowTexture.modulate.a = 0.5
	$Sprite2D/ArrowTexture.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_gravity_change(new_gravity: Vector2) -> void:
	get_tree().paused = true
	$Player/Sprite2D.rotation = atan2(new_gravity.y, new_gravity.x) - PI/2
	$Sprite2D/ArrowTexture.rotation = atan2(new_gravity.y, new_gravity.x) + PI/2
	$Sprite2D/ArrowTexture.show()
	await get_tree().create_timer(0.1).timeout
	$Sprite2D/ArrowTexture.hide()
	get_tree().paused = false
	
