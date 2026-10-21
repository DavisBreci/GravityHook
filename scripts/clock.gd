extends Node2D
const number_sheet_width = 20
const number_sheet_height = 10
var time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	time += 0.1
	if increment_Node($decis):
		if increment_Node($seconds):
			if increment_Node_base6($tens):
				increment_Node($minutes)
