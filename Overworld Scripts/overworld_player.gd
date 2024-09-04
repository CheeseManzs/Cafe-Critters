extends CharacterBody3D
var target_velocity = Vector3.ZERO
var bubble
var stored_dir = 0
var speed = 3
var fall_accel = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	var sprite = $CollisionShape3D/Sprite3D
	if Input.is_action_pressed("ui_right"):
		stored_dir = 0
		direction.x += 1
		sprite.play("move_right")
	if Input.is_action_pressed("ui_left"):
		stored_dir = 1
		direction.x -= 1
		sprite.play("move_left")
	if Input.is_action_pressed("ui_down"):
		stored_dir = 2
		direction.z += 1
		sprite.play("move_front")
	if Input.is_action_pressed("ui_up"):
		stored_dir = 3
		direction.z -= 1
		sprite.play("move_back")

	if direction != Vector3.ZERO:
		direction = direction.normalized()
	else:
		match stored_dir:
			0:
				sprite.play("idle_right")
			1:
				sprite.play("idle_left")
			2:
				sprite.play("idle_front")
			3:
				sprite.play("idle_back")
		#$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = -(fall_accel * delta)
		fall_accel *= 1.1
	else:
		fall_accel = 0.1

	# Moving the Character
	velocity = target_velocity
	move_and_slide()


func _on_area_3d_area_entered(area: Area3D) -> void:
	var newNode = area.speechBubble.instantiate()
	bubble = newNode.get_node("Sprite3D")
	bubble.spawnAnim(area.position + Vector3(0, 0.5,0))
	area.add_child(newNode)
	pass # Replace with function body.


func _on_area_3d_area_exited(area: Area3D) -> void:
	bubble.despawnAnim()
	pass # Replace with function body.
