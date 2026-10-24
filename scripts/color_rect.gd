extends ColorRect

signal animation_complete

var default_radius
var target: Node2D
var shrink_speed = 600

func _ready() ->void:
	default_radius = sqrt(pow(size.x,2) + pow(size.y,2))
	material.set_shader_parameter("radius", default_radius)

func _process(delta: float) -> void:
	if target == null:
		return
	var screen_pos = target.get_global_transform_with_canvas().origin
	var uv_pos = screen_pos / size
	material.set_shader_parameter("center", uv_pos)
	material.set_shader_parameter("rect_size", size)
	var radius = material.get_shader_parameter("radius")
	radius = maxf(radius - shrink_speed * delta, 0.0)
	material.set_shader_parameter("radius", radius)
	if(radius == 0.0):
		animation_complete.emit()
func reset_shader() -> void:
	material.set_shader_parameter("radius", default_radius)
	target = null
