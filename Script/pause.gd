extends Control



func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("Blur")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("Blur")
func testesc():
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		resume()
	
	

func _on_resume_pressed() -> void:
	resume()


func _on_options_pressed() -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()

func _process(_delta):
	testesc()
