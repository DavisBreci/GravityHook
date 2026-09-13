extends CharacterBody2D
var fall_speed
var gravity
var gravity_direction
var collision_vector
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fall_speed = 0
	position.x = 100
	gravity = 10
	gravity_direction = Vector2(0,1)

var was_on_floor = false
var was_on_ceiling = false
var was_on_wall = false
func _physics_process(delta: float) -> void:
	move_and_slide()
	collision_vector = Vector2.ZERO
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		collision_vector += normal
	if collision_vector.x != 0 and not was_on_wall:
		var cos_theta = (Vector2((-1) * collision_vector.x,0)).dot(get_real_velocity().normalized())
		if cos_theta > 0.8:
			gravity_direction = Vector2((-1 * collision_vector.x), 0)
	if collision_vector.y > 0 and not was_on_ceiling:
		gravity_direction = Vector2(0,-1)
	elif collision_vector.y < 0 and not was_on_floor:
		gravity_direction = Vector2(0,1)
	was_on_floor = is_on_floor()
	was_on_ceiling = is_on_ceiling()
	was_on_wall = is_on_wall()
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x += -250
	if Input.is_action_pressed("move_right"):
		velocity.x += 250
	if Input.is_action_pressed("move_up"):
		velocity.y += -250
	if Input.is_action_pressed("move_down"):
		velocity.y += 250
	velocity -= velocity * abs(gravity_direction)
	var is_airborne = not (is_on_floor() or is_on_ceiling() or is_on_wall())
	if not is_airborne:
		fall_speed = 10
		if Input.is_action_just_pressed("jump"):
			gravity_direction *= -1
	if is_airborne:
		fall_speed += (gravity * 0.2) if Input.is_action_pressed("jump") else gravity
	velocity += gravity_direction * fall_speed
