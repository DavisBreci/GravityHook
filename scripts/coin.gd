extends Sprite2D
signal collected_signal

var Player: Node2D
var collected: bool
var start_position: Vector2

func _ready() -> void:
	collected = false
	start_position = global_position

func _process(delta: float) -> void:
	if not collected:
		return
	var to_player = Player.global_position - global_position
	if to_player.length() < 10.0:
		return
	global_position += to_player * 0.25

func _on_area_2d_body_entered(body: Node2D) -> void:
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	collected = true
	Player = body

func reset_coin() -> void:
	global_position = start_position
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
	collected = false
	Player = null
