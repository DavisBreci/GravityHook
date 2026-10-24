extends Node2D
const number_sheet_width = 20
const number_sheet_height = 10
var time: float
var freeze: bool = false

func increment_Node(digit: Sprite2D) -> bool:
	var window = digit.region_rect
	var carry = false
	window.position[0] += window.size[0]
	if window.position[0] >= number_sheet_width:
		window.position[0] = 0
		window.position[1] += window.size[1]
		if window.position[1] >= number_sheet_height:
			window.position[1] = 0
			carry = true
	digit.region_rect = window
	return carry

func increment_Node_base6(digit: Sprite2D) -> bool:
	increment_Node(digit)
	if digit.region_rect.position == Vector2(4,5):
		digit.region_rect.position = Vector2(0,0)
		return true
	return false

func increment() -> void:
	if freeze:
		return
	time += 0.1
	if increment_Node($decis):
		if increment_Node($seconds):
			if increment_Node_base6($tens):
				increment_Node($minutes)

func reset_clock() -> void:
	time = 0.0
	$decis.region_rect.position = Vector2(0,0)
	$seconds.region_rect.position = Vector2(0,0)
	$tens.region_rect.position = Vector2(0,0)
	$minutes.region_rect.position = Vector2(0,0)
	freeze = false
