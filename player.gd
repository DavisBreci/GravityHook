extends CharacterBody2D
var fall_speed
var gravity
var gravity_direction
var collision_vector
var direction = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fall_speed = 0
	position.x = 100
	gravity = 10
	gravity_direction = Vector2(0,1)

func _physics_process(delta: float) -> void:
	move_and_slide()
	var is_airborne = (not is_on_floor() and gravity_direction == Vector2(0,1)) or (not is_on_ceiling() and gravity_direction == Vector2(0,-1)) or (not is_on_wall() and gravity_direction.x != 0)
	collision_vector = Vector2.ZERO
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		collision_vector += normal
	var cos_theta
	if collision_vector.x != 0:
		cos_theta = (Vector2((-1) * collision_vector.x, 0)).dot(get_real_velocity().normalized())
		if cos_theta > 0.9:
			gravity_direction = Vector2((-1 * collision_vector.x), 0)
	if collision_vector.y > 0:
		cos_theta = (Vector2(0,-1)).dot(get_real_velocity().normalized())
		if cos_theta > 0.9:
			gravity_direction = Vector2(0,-1)
	if collision_vector.y < 0:
		cos_theta = (Vector2(0,1)).dot(get_real_velocity().normalized())
		if cos_theta > 0.9:
			gravity_direction = Vector2(0,1)
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x += -400
	if Input.is_action_pressed("move_right"):
		velocity.x += 400
	if Input.is_action_pressed("move_up"):
		velocity.y += -400
	if Input.is_action_pressed("move_down"):
		velocity.y += 400
	if Input.is_action_pressed("dash"):
		velocity *= 1.8
	velocity -= velocity * abs(gravity_direction)
	if not is_airborne:
		fall_speed = 200
		if Input.is_action_just_pressed("jump"):
			gravity_direction *= -1
			velocity += gravity_direction * fall_speed
	if is_airborne:
		fall_speed += gravity
		velocity += gravity_direction * fall_speed
	direction = velocity.normalized()
