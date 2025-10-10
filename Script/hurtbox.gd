class_name hurtbox
extends Area2D

@onready var player = get_parent()

var can_take_damage = true  # Cooldown flag
@export var invincibility_time := 0.5  # Seconds of invulnerability after a hit

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	if not can_take_damage:
		return

	if area is hitbox:  # Uses your class_name "hitbox"
		can_take_damage = false
		player.take_damage(area.damage)  # Pass in damage from the hitbox
		await get_tree().create_timer(invincibility_time).timeout
		can_take_damage = true
