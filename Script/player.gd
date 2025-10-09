extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health = $Health   # 👈 add this (make sure you have a Health node under Player)

const SPEED = 120
const JUMP_VELOCITY = -400.0

var respawn_point: Vector2

func _ready() -> void:
	# Save the player's starting position as the default respawn point
	respawn_point = global_position

	# Connect to health signals 👇
	health.connect("health_changed", Callable(self, "_on_health_changed"))
	health.connect("died", Callable(self, "_on_died"))

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

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Run")
	else:
		animated_sprite.play("Jump")

	move_and_slide()


# --- HEALTH SYSTEM INTEGRATION ---

func _on_health_changed(current: int, max: int) -> void:
	print("❤️ Player HP:", current, "/", max)

func _on_died() -> void:
	print("💀 Player died!")
	kill()  # respawn on death


# --- DAMAGE / HEAL FUNCTIONS (you can call these from enemies, spikes, etc.) ---

func take_damage(amount: int) -> void:
	health.take_damage(amount)

func heal(amount: int) -> void:
	health.heal(amount)


# --- Existing KillZone respawn function ---
func kill() -> void:
	global_position = respawn_point
	velocity = Vector2.ZERO
	health.current_health = health.max_health  # restore full HP on respawn
	print("💀 Player hit KillZone — respawned instantly!")
