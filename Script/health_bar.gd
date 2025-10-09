extends Control


@onready var bar: TextureProgressBar = $TextureProgressBar
@export var health_node_path: NodePath = NodePath("../Player/Health")

var health_node: Node

func _ready():
	# Find the health node
	health_node = get_node_or_null(health_node_path)
	if health_node:
		# Connect to health signals
		health_node.connect("health_changed", Callable(self, "_on_health_changed"))
		# Initialize display
		_on_health_changed(health_node.current_health, health_node.max_health)

func _on_health_changed(current: int, max: int):
	bar.max_value = max
	bar.value = current
