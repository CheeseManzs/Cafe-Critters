extends CharacterBody3D
var target_velocity = Vector3.ZERO
var directionLR = "none"
var directionUD = "down"
var prevDirLR = directionLR
var prevDirUD = directionUD
var buffer = 0
var bufferTime = 0.125
var speed = 3
var fall_accel = 0.1
var targetNPC = null
var npcBubble
var npcBubbleNode
@onready var spriteNode = $CollisionShape3D/Sprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _physics_process(delta: float) -> void:
	doMovement(delta)
	print(prevDirLR)
	print(prevDirUD)
	#jesus christ i'm putting this in its own function this is a nightmare
	

func doMovement(delta: float) -> void:
	var direction = Vector3.ZERO
	var sprite = $CollisionShape3D/Sprite3D
	var bufferChange = false
	buffer += delta
	if (directionLR != "none" or directionUD != "none") and buffer > bufferTime: 
		prevDirLR = directionLR
		bufferChange = true
	if (directionLR != "none" or directionUD != "none") and buffer > bufferTime: 
		prevDirUD = directionUD
		bufferChange = true
	if bufferChange: buffer = 0
	directionLR = "none"
	directionUD = "none"
	if Input.is_action_pressed("ui_right"):
		directionLR = "right"
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		directionLR = "left"
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		directionUD = "down"
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		directionUD = "up"
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
	sprite.play(setAnimation(directionLR, directionUD, direction == Vector3.ZERO, false))

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

func setAnimation(facingLR: String, facingUD: String, isMoving: bool, inRecursion: bool) -> String:
	match facingUD:
		"up":
			match facingLR:
				"left":
					if isMoving:
						return "idle_up_left"
					else:
						return "move_up_left"
				"right":
					if isMoving:
						return "idle_up_right"
					else:
						return "move_up_right"
				"none":
					if isMoving:
						return "idle_up"
					else:
						return "move_up"
		"down":
			match facingLR:
				"left":
					if isMoving:
						return "idle_down_left"
					else:
						return "move_down_left"
				"right":
					if isMoving:
						return "idle_down_right"
					else:
						return "move_down_right"
				"none":
					if isMoving:
						return "idle_down"
					else:
						return "move_down"
		"none":
			match facingLR:
				"left":
					if isMoving:
						return "idle_left"
					else:
						return "move_left"
				"right":
					if isMoving:
						return "idle_right"
					else:
						return "move_right"
				"none":
					if inRecursion:
						pass
					else:
						return setAnimation(prevDirLR, prevDirUD, isMoving, true)
						pass
						
	return "idle_down"

func _on_area_3d_area_entered(area: Area3D) -> void:
	if "areaName" in area:
		match area.areaName:
			"NPC":
				npcBubbleNode = area.speechBubble.instantiate()
				targetNPC = area.get_parent_node_3d()
				npcBubble = npcBubbleNode.get_node("Sprite3D")
				npcBubble.spawnAnim(area.position + Vector3(0, 0.5,0))
				area.add_child(npcBubbleNode)
	pass # Replace with function body.

func _on_area_3d_area_exited(area: Area3D) -> void:
	if "areaName" in area:
		match area.areaName:
			"NPC":
				npcBubble.despawnAnim()
				targetNPC = null
	pass # Replace with function body.
