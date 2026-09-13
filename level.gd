extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ArrowTexture.rotation = atan2($Player.gravity_direction.y, $Player.gravity_direction.x) + PI/2
