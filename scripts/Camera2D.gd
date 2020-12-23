extends Node2D

const speed = 200.0

func _process(delta):
	if Input.is_action_pressed('ui_left'):
		position.x -= delta*speed
	if Input.is_action_pressed('ui_right'):
		position.x += delta*speed
	if Input.is_action_pressed('ui_up'):
		position.y -= delta*speed
	if Input.is_action_pressed('ui_down'):
		position.y += delta*speed
	pass
