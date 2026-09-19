extends StaticBody2D
signal can_hook

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	$Area2D/CollisionShape2D.shape.radius = 200
	$RingSprite.modulate.a = 0.2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	$RingSprite.modulate.a = 1.0
	print("entered")
	can_hook.emit(true, self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	$RingSprite.modulate.a = 0.2
	print("exited")
	can_hook.emit(false, self)
