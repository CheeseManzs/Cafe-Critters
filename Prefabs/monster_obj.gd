extends Node3D

#total "time elapsed" tracker
var t = 0.0
#link to monster data structure
var monsterData: Resource
#bool to check if monster is controlled by player
var playerControlled
#id of the monster relative to its team (player or opponent)
var teamID = 0
#magnitude at which the monster "bobs" up and down in battle
var idleStrength = 0.05
#random offset for bobbing
var randOffset = 0
#rng struct
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#grab monster data from metadata
	monsterData = get_meta("Monster_Data")
	#set sprite to the monster this object represents
	$Sprite3D.texture = monsterData.sprite
	#grab player-controlled boolean from metadata
	playerControlled = get_meta("playerControlled")
	print(monsterData)
	#generate the bobbing offset
	randOffset = rng.randf_range(0, 20)

# Returns intended position of monster (using its teamID and designation as a player/enemy monster)
func getMonsterPosition() -> Vector3:
	#base position for a player controlled monster
	var pos = Vector3(-2, 0.953, 0)
	if !playerControlled:
		#flip the position across the origin if its an enemy monster
		pos.x *= -1
	return pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#calculate and set the monster position to the intended position
	position =  getMonsterPosition()
	
	#calculate the delta for the bobbing
	var bobDelta = idleStrength*sin(t + randOffset)
	
	if playerControlled:
		#if monster is player controlled, rotate the sprite 180 degrees
		$Sprite3D.rotation_degrees = Vector3(0, 180, 0)
	else:
		#if the monster is enemy controlled, no sprite rotation is needed
		$Sprite3D.rotation_degrees = Vector3(0, 0, 0)
	
	#change the scale of the sprite to simulate bobbing
	$Sprite3D.scale = Vector3(1, (1 - idleStrength) + bobDelta,  1)
	#to anchor it at the bottom, add (delta - max)/2 to the position of the **sprite** (not actual monster)
	$Sprite3D.position = Vector3(0, (bobDelta - idleStrength)/2, 0)
	#update the total time by adding the delta time to the tracker
	t += delta
