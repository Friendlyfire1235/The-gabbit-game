extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hearts_parent = $HBoxContainer

const SPEED = 140
const JUMP_VELOCITY = -300.0
const INVINCIBILITY_TIME = 1.5  # seconds

var hearts_list: Array = []
var health = 3
var alive = true
var is_taking_hit = false
var invincible = false

func _ready() -> void:
	for child in hearts_parent.get_children():
		if child is TextureRect:
			hearts_list.append(child)
	update_heart_display()
	add_to_group("Player")

func take_damage(damage: int = 1) -> void:
	if not alive or is_taking_hit or invincible:
		return  # Ignore hits while dead, taking hit, or invincible

	if health > 0:
		health -= damage
		is_taking_hit = true
		invincible = true
		animated_sprite.play("Hit")
		update_heart_display()

		# Flash effect for invincibility
		flash_invincibility()

		# Wait for hit animation to finish
		await animated_sprite.animation_finished
		is_taking_hit = false

		# Wait out invincibility time
		await get_tree().create_timer(INVINCIBILITY_TIME).timeout
		invincible = false
		animated_sprite.modulate = Color(1, 1, 1, 1)  # Reset to normal

	if health <= 0:
		death()

func flash_invincibility():
	var flashes = 4 
	for i in range(flashes):
		animated_sprite.modulate = Color(1, 1, 1, 0.4)
		await get_tree().create_timer(0.1).timeout
		animated_sprite.modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(0.1).timeout

func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health

func death():
	if not alive:
		return
	alive = false
	animated_sprite.play("Death")
	await animated_sprite.animation_finished
	get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	if not alive or is_taking_hit:
		return  # Stop movement and animation changes while hit or dead

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("Move_left", "Move_right")

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Run")
	else:
		animated_sprite.play("Jump")

	move_and_slide()
 
