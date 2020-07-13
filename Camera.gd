extends Camera
export(float) var moveSpeed = 0.005
export(float) var zoomSpeed = 10.0
var motion := Vector3()
var velocity := Vector3()

var initialRotation := rotation.y


func _process(_delta):
	if Input.is_action_pressed("move_forward"):
		
		motion.y = moveSpeed
	elif Input.is_action_pressed("move_backward"):
		motion.y = -moveSpeed
	else:
	
		motion.y = 0
	
	if(Input.is_action_pressed("move_left")):
		motion.x = -moveSpeed
		motion.z = moveSpeed
	elif(Input.is_action_pressed("move_right")):
		motion.x = moveSpeed
		motion.z = -moveSpeed
	else:
		motion.x = 0
		motion.z = 0
	if(Input.is_action_just_released("zoom_in")):
		var testSize = size + zoomSpeed
		if testSize > 16300:
			size = 16300
		else:	
			size = testSize		
	elif(Input.is_action_just_released("zoom_out")):
		var testSize = size - zoomSpeed
		if testSize < 0:
			size = 1
		else:	
			size = testSize		
	
		
	
	translation += motion
