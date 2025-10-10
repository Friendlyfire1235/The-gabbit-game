extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var move_speed := 20

var move_direction: int = 0
var wander_time: float = 0.0

func randomize_wander():
	# Pick a random direction: left (-1), right (1), or idle (0)
	var choices = [-1, 1]
	move_direction = choices[randi() % choices.size()]
	wander_time = randf_range(1, 3)

func enter():
	randomize_wander()

func Update(_delta: float):
	if wander_time > 0:
		wander_time -= _delta
	else:
		randomize_wander()

func Physics_update(delta: float):
	if not enemy:
		return

	# Apply built-in gravity
	enemy.velocity.y += enemy.get_gravity().y * delta

	# Move only horizontally
	enemy.velocity.x = move_direction * move_speed

	# Actually move and detect floor/walls
	enemy.move_and_slide()

	# Optional: Flip sprite if exists
	if move_direction != 0 and enemy.has_node("AnimatedSprite2D"):
		enemy.get_node("AnimatedSprite2D").flip_h = move_direction < 0
