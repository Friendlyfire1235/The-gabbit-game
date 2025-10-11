extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var move_speed := 20

var player: CharacterBody2D
var move_direction: Vector2
var wander_time: float

func randomize_wander():
	# Only move left or right for side-view
	move_direction = Vector2(randf_range(-1, 1), 0).normalized()
	wander_time = randf_range(1, 3)

func enter():
	player = get_tree().get_first_node_in_group("player")
	randomize_wander()

func Update(_delta: float):
	if wander_time > 0:
		wander_time -= _delta
	else:
		randomize_wander()

func Physics_update(delta: float):
	if not enemy:
		return

	enemy.velocity = move_direction * move_speed

	var direction = player.global_position - enemy.global_position
	

	if direction.length() < 30:
		Transitioned.emit(self, "EnemyFollow")

	enemy.move_and_slide()
