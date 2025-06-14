class_name OverworldPlayer
extends Node3D

signal dialogue_opened
signal dialogue_passed
signal dialogue_closed

static var singleton: OverworldPlayer
@export_multiline var defaultTeam: String
var playerTeam: Array[Monster]
@export var playerBox: Array[Monster]
@export var inventory: Inventory = Inventory.new()

# final player velocity. used in case i make gravity use a persistent value
var targetVelocity = Vector3.ZERO

# tracking values to store the player's facing direction. used for animation selection
var directionLR = "none"
var directionUD = "down"
var prevDirLR = directionLR
var prevDirUD = directionUD

# timer that artificially slows how quickly the player can change facing directions.
var buffer = 0
var bufferTime = 0.125

# physics constants.
var speed = 3
var fall_accel = 0.1

# stores the NPC you've approached most recently, as well as their pop-up speech bubble and its script.
# needs to be reworked so that it can track the NPC you're closest to.
var targetNPC = null
var npcBubble
var npcBubbleNode

# game controls change slightly while dialog is showing so this tracks that
var inDialog = false

# holder for the physical inventory ui
var inventoryUI# = load("res://Prefabs/inventory_ui.tscn").instantiate()
var doingInventory = false

@onready var spriteNode = $CharacterBody3D/CollisionShape3D/Sprite3D
@onready var characterNode = $CharacterBody3D
@onready var cameraNode = $Camera3D
@onready var cameraOffset = $Camera3D.position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	singleton = self
	playerTeam = ConnectionManager.singleton.teamPacker.decode(defaultTeam)
	#add_child(inventoryUI)
	inventory.addItems("ingr_anvi_5", 3)
	inventory.addItems("ingr_anvi_2", 3)
	pass # Replace with function body.

func toggleInventory(state):
	doingInventory = true
	if state:
		%InventoryUI.isOpening = true
		%InventoryUI.updateItems(inventory, 0)
	else:
		%InventoryUI.isOpening = false

func setTeam(newTeam: Array[Monster]):
	playerTeam = []
	for mon in newTeam:
		if mon != null:
			playerTeam.push_back(mon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# detects when z is pressed in range of an NPC. action changes depending on player state
	if Input.is_action_just_pressed("control_primary") && targetNPC != null:
		if inDialog:
			# tells the text handler (dialogue_box.gd) that z was pressed.
			# dialogue_box.gd handles what actually happens.
			dialogue_passed.emit()
			pass
		else:
			# queries the NPC to see what text should be spoken then passes it to the text handler
			var curText = targetNPC.interactSpeak()
			if curText != null:
				dialogue_opened.emit(curText)
				inDialog = true
		print("SHIT")
	pass
	
	# makes it so you can only change inventory state when the animation is finished
	if %InventoryUI.timer == 0 or %InventoryUI.timer == 1:
		doingInventory = false
	# detects when esc is pressed and toggles the inventory
	# inventory_ui.gd gets fed the Inventory object, which isn't just a dict lol
	
	

# called every physics frame
func _physics_process(delta: float) -> void:
	# does movement if not speaking. maybe should be split into gravity vs movement?
	if !inDialog:
		doMovement(delta)
	pass
	# move the camera
	cameraNode.position = cameraNode.position.lerp(characterNode.position + cameraOffset, delta * 5)
	#cameraNode.position += Vector3(0, 0, 0.001)
	

func doMovement(delta: float) -> void:
	# movement direction tracking
	var direction = Vector3.ZERO
	
	var bufferChange = false
	buffer += delta
	
	# tracks the most recent direction the player moved in that isn't "no direction"
	# buffer ensures this value doesn't update too frequently so it can capture
	# diagonal movements (players can't release both movement keys in <1 physics frame)
	if (directionLR != "none" or directionUD != "none") and buffer > bufferTime: 
		prevDirLR = directionLR
		bufferChange = true
	if (directionLR != "none" or directionUD != "none") and buffer > bufferTime: 
		prevDirUD = directionUD
		bufferChange = true
	if bufferChange: buffer = 0
	directionLR = "none"
	directionUD = "none"
	
	# tracks movement keys and ensures the game knows which way they're facing and which direction 
	# they should be moving
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

	# turns direction vector into a unit vector.
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
	# changes player's animation dependent on whether or not they're moving and which way they're facing
	spriteNode.play(setAnimation(directionLR, directionUD, direction == Vector3.ZERO, false))

	# Ground Velocity
	targetVelocity.x = direction.x * speed
	targetVelocity.z = direction.z * speed

	# Vertical Velocity
	if not characterNode.is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		targetVelocity.y = -(fall_accel * delta)
		fall_accel *= 1.1
	else:
		fall_accel = 0.1

	# Moving the Character
	characterNode.velocity = targetVelocity
	characterNode.move_and_slide()

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
						# animation fallback when the player isn't moving at all
						# uses the last direction they moved in to determine facing direction
						return setAnimation(prevDirLR, prevDirUD, isMoving, true)
						pass
						
	#code never touches this point
	return "idle_down"

func _on_area_3d_area_entered(area: Area3D) -> void:
	# custom "areaName" property on area script allows for customized behaviour when interacting
	# with player. protects from unintended crashing and you don't need to check if_exists(get_node) each time
	if "areaName" in area:
		match area.areaName:
			"NPC":
				# causes "speech bubble" to pop up when approaching an NPC and stores it to memory
				npcBubbleNode = area.speechBubble.instantiate()
				targetNPC = area.get_parent_node_3d()
				npcBubble = npcBubbleNode.get_node("Sprite3D")
				
				# plays bubble spwaning animation and adds it to the scene
				npcBubble.spawnAnim(area.position + Vector3(0, 0.5,0))
				area.add_child(npcBubbleNode)
	pass # Replace with function body.

func _on_area_3d_area_exited(area: Area3D) -> void:
	# custom "areaName" property on area script allows for customized behaviour when interacting
	# with player. protects from unintended crashing and you don't need to check if_exists(get_node) each time
	if "areaName" in area:
		match area.areaName:
			"NPC":
				# causes "speech bubble" to disappear
				npcBubble.despawnAnim()
				targetNPC = null
	pass # Replace with function body.


func _on_panel_close_dialog() -> void:
	inDialog = false
	pass # Replace with function body.


func _on_dialog_panel_starting_battle(enemyTeam, enemyAI) -> void:
	BattleController.startBattle(playerTeam, enemyTeam, enemyAI)
	pass # Replace with function body.
