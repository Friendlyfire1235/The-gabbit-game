extends CharacterBody2D

@onready var state_machine = $StateMachine  # adjust if your node is named differently

func _physics_process(delta: float) -> void:
	if state_machine:
		state_machine._physics_process(delta)

	
