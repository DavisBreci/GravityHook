extends CharacterBody2D
signal gravity_change
var fall_speed
const GRAVITY = 16
var gravity_direction
var is_airborne = true
const SPEED = 400
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fall_speed = 0
	position.x = 100
	gravity_direction = Vector2(0,1)
	velocity = Vector2(0,0)

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
	
	velocity = Vector2.ZERO
	var input = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input += Vector2(-1,0)
	if Input.is_action_pressed("move_right"):
		input += Vector2(1,0)
	if Input.is_action_pressed("move_up"):
		input += Vector2(0,-1)
	if Input.is_action_pressed("move_down"):
		input += Vector2(0,1)
	velocity = input * SPEED
	if Input.is_action_pressed("dash"):
		velocity *= 1.8
	if gravity_direction.x != 0:
		velocity.x = 0
	elif gravity_direction.y != 0:
		velocity.y = 0
	if not is_airborne:
		fall_speed = 200
		if Input.is_action_just_pressed("jump"):
			is_airborne = true
			set_gravity((-1)*gravity_direction)
			velocity += gravity_direction * fall_speed
	if is_airborne:
		fall_speed += GRAVITY
		velocity += gravity_direction * fall_speed
