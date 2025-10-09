# Health.gd
extends Node

# --- Signals ---
signal health_changed(current, max)
signal died

# --- Variables ---
@export var max_health: int = 100
var current_health: int

func _ready():
	current_health = max_health
	emit_signal("health_changed", current_health, max_health)

# --- Take Damage ---
func take_damage(amount: int) -> void:
	if amount <= 0:
		return
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	print("Took", amount, "damage! Current HP:", current_health)
	emit_signal("health_changed", current_health, max_health)

	if current_health == 0:
		print("Entity died.")
		emit_signal("died")

# --- Heal ---
func heal(amount: int) -> void:
	if amount <= 0:
		return
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	print("Healed", amount, "HP! Current HP:", current_health)
	emit_signal("health_changed", current_health, max_health)

# --- Utility ---
func is_alive() -> bool:
	return current_health > 0
