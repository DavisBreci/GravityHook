extends CharacterBody2D
signal gravity_change
var fall_speed = 0
const GRAVITY = 16
var gravity_direction = Vector2(0,1)
var is_airborne = true
const SPEED = 400
var directional_input = Vector2.ZERO
var button_input = [false, false]
enum buttons {
	JUMP = 0,
	DASH = 1
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = 100
	velocity = Vector2.ZERO

func _process(delta: float) -> void:
	directional_input = Vector2.ZERO
	button_input = [false, false]
	if Input.is_action_pressed("move_left"):
		directional_input += Vector2(-1,0)
	if Input.is_action_pressed("move_right"):
		directional_input += Vector2(1,0)
	if Input.is_action_pressed("move_up"):
		directional_input += Vector2(0,-1)
	if Input.is_action_pressed("move_down"):
		directional_input += Vector2(0,1)
	if Input.is_action_pressed("jump"):
		button_input[buttons.JUMP] = true
	if Input.is_action_pressed("dash"):
		button_input[buttons.DASH] = true

func set_gravity(new_direction: Vector2) -> void:
	if gravity_direction != new_direction:
		gravity_change.emit(new_direction)
		gravity_direction = new_direction

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity*delta, false, 0.2, true)
	var normal = Vector2.ZERO
	if collision:
		normal = collision.get_normal()
		if normal.x != 0:
			position.y += collision.get_remainder().y
		else:
			position.x += collision.get_remainder().x
	
	if normal == Vector2.ZERO:
		is_airborne = true
	else:
		if normal + gravity_direction == Vector2.ZERO or velocity.normalized().dot(normal) < -0.95:
			is_airborne = false
			set_gravity((-1)*normal)
	
	velocity = directional_input * SPEED
	if button_input[buttons.DASH]:
		velocity *= 1.8
	if gravity_direction.x != 0:
		velocity.x = 0
	elif gravity_direction.y != 0:
		velocity.y = 0
	if not is_airborne:
		fall_speed = 200
		if button_input[buttons.JUMP]:
			is_airborne = true
			set_gravity((-1)*gravity_direction)
			velocity += gravity_direction * fall_speed
	if is_airborne:
		fall_speed += GRAVITY
		velocity += gravity_direction * fall_speed
