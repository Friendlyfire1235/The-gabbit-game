class_name Hurtbox
extends Area2D

@onready var player = get_parent()

var can_take_damage: bool = true  # Cooldown flag
@export var invincibility_time := 0.5  # Seconds of invulnerability after a hit

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	if not can_take_damage:
		return  # exit early if still invincible

	if area is hitbox:  # Uses your class_name "Hitbox"
		can_take_damage = false
		if player.has_method("take_damage"):
			player.take_damage(area.damage)  # Pass in damage from the hitbox
		# Use a timer to reset invincibility
		get_tree().create_timer(invincibility_time).timeout.connect(
			Callable(self, "_reset_invincibility")
		)

func _reset_invincibility() -> void:
	can_take_damage = true
