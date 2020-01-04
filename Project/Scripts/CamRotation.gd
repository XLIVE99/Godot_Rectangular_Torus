extends Camera

export (Vector3) var center
export (float) var distance

func _process(delta):
	transform.origin = center
	transform.origin = center + (transform.xform(Vector3.BACK) * distance)
	pass

func _input(event):
	if(Input.is_action_pressed("mouse_right")):
		if(event is InputEventMouseMotion):
			rotation_degrees += Vector3(-event.relative.y, event.relative.x, 0)
	pass