extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $stickguy
const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var spawn_point: Vector2   # NEW
var deaths := 0            # NEW

func _ready() -> void:     # NEW
	spawn_point = global_position

func _physics_process(delta: float) -> void:
	# Add Animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.play("running")
	else:
		animated_sprite_2d.play("idle")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# NEW: check what we touched this frame
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collision.get_collider().is_in_group("damage"):
			die()
			break

func die() -> void:        # NEW
	deaths += 1
	global_position = spawn_point
	velocity = Vector2.ZERO
