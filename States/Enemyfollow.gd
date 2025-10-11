extends State
class_name EnemyFollow

@export var enemy: CharacterBody2D 
@export var move_speed := 40

var player: CharacterBody2D

func enter():
	player = get_tree().get_first_node_in_group("player")

func Physics_update(_delta: float):
	if not enemy or not player:
		return

	var direction = player.global_position - enemy.global_position
	direction.y = 0  # <-- ignore vertical movement (side-view fix)

	if direction.length() > 25:
		enemy.velocity = direction.normalized() * move_speed
	else:
		enemy.velocity = Vector2.ZERO

	if direction.length() > 50:
		Transitioned.emit(self, "EnemyIdle")

	enemy.move_and_slide()
