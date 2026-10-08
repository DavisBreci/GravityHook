extends StaticBody2D
signal can_hook

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
#	$Area2D/CollisionShape2D.shape.radius = 200
	$AnimatedSprite2D.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	$AnimatedSprite2D.animation = "active"
	can_hook.emit(true, self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	$AnimatedSprite2D.animation = "inactive"
	can_hook.emit(false, self)
