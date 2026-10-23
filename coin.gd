extends Sprite2D
signal collected_signal

var collected: bool

func _ready() -> void:
	collected = false

func _process(delta: float) -> void:
	if not collected:
		return

func _on_area_2d_body_entered(body: Node2D) -> void:
	$Area2D/CollisionShape2D.disabled = true
	collected = true
	collected_signal.emit()
