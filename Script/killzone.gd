extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	# Check if the body is the player
	if body.is_in_group("Player"):
		# Instantly kill the player
		body.death()
