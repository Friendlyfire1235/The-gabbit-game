extends Control

@export var health_node_path: NodePath = NodePath("../Player/Health")
@export var full_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D

var health_node: Node

func _ready():
	# Find the player health node
	health_node = get_node_or_null(health_node_path)
	if health_node:
		health_node.connect("health_changed", Callable(self, "_on_health_changed"))
		_on_health_changed(health_node.current_health, health_node.max_health)

func _on_health_changed(current: int, max: int):
	var heart_count = get_child_count()
	for i in range(heart_count):
		var heart = get_child(i)
		if i < current:
			heart.texture = full_heart_texture
		else:
			heart.texture = empty_heart_texture
