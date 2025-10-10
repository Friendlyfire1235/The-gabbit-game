extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hearts_parent = $HBoxContainer

const SPEED = 140
const JUMP_VELOCITY = -300.0

var hearts_list: Array = []  # List of heart TextureRects
var health = 3
var alive = true

func _ready() -> void:
	for child in hearts_parent.get_children():
		if child is TextureRect:
			hearts_list.append(child)
	print(hearts_list)
	update_heart_display()

	# Add player to a group so KillZone can detect it
	add_to_group("Player")

func take_damage(damage: int = 1) -> void:
	if health > 0:
		health -= damage
		update_heart_display()
	if health <= 0:
		death()

func update_heart_display():
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < health
	


func death():
	if not alive:
		return  # Prevent multiple deaths
	print("Player has died")
	alive = false
	animated_sprite.play("Death")
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	if not alive:
		return

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
