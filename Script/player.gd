extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 120
const JUMP_VELOCITY = -400.0

var respawn_point: Vector2

func _ready() -> void:
	# Save the player's starting position as the default respawn point
	respawn_point = global_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle movement/deceleration.
	var direction := Input.get_axis("Move_left", "Move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0 :
		animated_sprite.flip_h = true
	#play animations
	if direction == 0 :
		animated_sprite.play("Idle")
	else:
		animated_sprite.play("Run")
	
	
	
	move_and_slide()

# Called by KillZone when the player dies
func kill() -> void:
	global_position = respawn_point
	velocity = Vector2.ZERO
	print("💀 Player hit KillZone — respawned instantly!")
