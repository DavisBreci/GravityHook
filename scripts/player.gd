extends CharacterBody2D
signal gravity_change
var fall_speed = 0
const GRAVITY = 600
var gravity_direction = Vector2(0,1)
var is_airborne = true
const SPEED = 400 # pixels per second
var directional_input = Vector2.ZERO
var button_input = [false, false, false]
var hookable_node = null
var is_swinging = false
enum buttons {
	JUMP = 0,
	DASH = 1,
	HOOK = 2
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = 100
	velocity = Vector2.ZERO
	for grapple_node in get_tree().get_nodes_in_group("GrappleNodes"):
		grapple_node.can_hook.connect(_on_grapple_node_can_hook)

func _process(delta: float) -> void:
	reset_input()
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
	if Input.is_action_pressed("hook"):
		button_input[buttons.HOOK] = true

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
		if normal + gravity_direction == Vector2.ZERO or velocity.normalized().dot(normal) < -0.9:
			is_airborne = false
			set_gravity((-1)*normal)
	
	var can_hook = hookable_node and button_input[buttons.HOOK] and not (hookable_node.position - position).normalized().dot(gravity_direction) > 0.2
	if not can_hook:
		velocity = directional_input * SPEED
		if gravity_direction.x != 0:
			velocity.x = 0
		elif gravity_direction.y != 0:
			velocity.y = 0
		if button_input[buttons.DASH]:
			velocity *= 1.8
		if not is_airborne:
			if button_input[buttons.JUMP]:
				is_airborne = true
				set_gravity((-1)*gravity_direction)
				velocity += gravity_direction * GRAVITY * delta

	if is_airborne:
		velocity += gravity_direction * GRAVITY
	
	if can_hook:
		velocity += directional_input * SPEED
		var to_node = (hookable_node.position - position).normalized()
		velocity -= to_node * velocity.dot(to_node)
		velocity += GRAVITY * gravity_direction * 0
	

func set_gravity(new_direction: Vector2) -> void:
	if gravity_direction != new_direction:
		reset_input()
		gravity_change.emit(new_direction)
		gravity_direction = new_direction

func reset_input() -> void:
	directional_input = Vector2.ZERO
	button_input = [false, false, false]

func _on_grapple_node_can_hook(hookable: bool, node: Object) -> void:
	if hookable:
		hookable_node = node
	elif hookable_node == node:
			hookable_node = null
