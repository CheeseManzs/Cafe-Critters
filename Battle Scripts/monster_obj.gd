class_name MonsterDisplay
extends Node3D

@export var shieldParticles: GPUParticles3D
@export var boostParticles: GPUParticles3D
@export var unboostParticles: GPUParticles3D
@export var empowerParticles: GPUParticles3D
@export var sprite: Sprite3D
#total "time elapsed" tracker
var t = 0.0
#link to monster data structure
var monsterData: Monster
#bool to check if monster is controlled by player
var playerControlled
#id of the monster relative to its team (player or opponent)
var teamID = 0
#magnitude at which the monster "bobs" up and down in battle
var idleStrength = 0.05
#random offset for bobbing
var randOffset = 0
#bobbing addition/multipler
var bobAddition: float = 0
var bobMultiplier: float = 1
#rng struct
var rng = RandomNumberGenerator.new()
var jumping = false
#connected battle mon
var connectedMon: BattleMonster
#ko checker
var faintAnimated = false
var lockToIntendedPosition = true
var lastDelta = 0


func getHeight() -> float:
	return sprite.texture.get_height()*sprite.pixel_size

# Reloads monster from metadata
func reloadMonster() -> void:
	monsterData = get_meta("Monster_Data")
	#set sprite to the monster this object represents
	sprite.texture = monsterData.sprite
	sprite.pixel_size *= monsterData.spriteScale

func faintAnimation(delta: float):
	if faintAnimated:
		return
	faintAnimated = true	
	var elapsed: float = 0
	var timeMax: float = 1
	while elapsed < timeMax:
		bobMultiplier = 1 - elapsed/timeMax
		elapsed += delta*2
		await get_tree().create_timer(delta/10).timeout
	bobMultiplier = 0

func hitAnimation() -> void:
	lockToIntendedPosition = false
	var elapsed: float = 0
	var timeMax: float = 0.5
	var back: int = 1
	if playerControlled:
		back = -1
	
	while elapsed < timeMax:
		var progress: float = elapsed/timeMax
		position += Vector3(2*lastDelta*back*(1 - progress), 0, 0)
		elapsed += lastDelta
		await get_tree().create_timer(lastDelta).timeout
	await get_tree().create_timer(0.1).timeout
	lockToIntendedPosition = true

func contactReturn(timeMax, originalPos, deltaPos, dashFraction) -> void:
	var elapsed = 0
	await get_tree().create_timer(0.2).timeout
	while elapsed < timeMax/2:
		var a_progress: float = elapsed/(timeMax/2.0)
		var progress: float = (1 - dashFraction) + dashFraction*elapsed/(timeMax/2.0)
		position = originalPos + deltaPos*pow(1 - progress, 3)
		sprite.modulate.a = (a_progress)
		elapsed += lastDelta
		await get_tree().create_timer(lastDelta).timeout
	#sprite.modulate.a = 1
	await get_tree().create_timer(0.1).timeout
	lockToIntendedPosition = true


func contactAnimation(target: MonsterDisplay) -> void:
	lockToIntendedPosition = false
	var elapsed: float = 0
	var timeMax: float = 0.3
	var distance: float = 1.8*abs(getMonsterPosition().x)
	var dashFraction = 0.5
	var back: int = 1
	if playerControlled:
		back = -1
	
	var originalPos = position
	var deltaPos = (target.global_position - global_position)
	elapsed = 0
	connectedMon.battleController.dashParticles.process_material.direction.x = -back
	connectedMon.battleController.dashParticles.position = originalPos
	var deltaAngle = acos((deltaPos).normalized().x)
	connectedMon.battleController.dashParticles.rotation_degrees = Vector3(0,0,deltaAngle)
	connectedMon.battleController.dashParticles.emitting = true
	while elapsed < timeMax/2:
		var a_progress: float = elapsed/(timeMax/2.0)
		var progress: float = dashFraction*elapsed/(timeMax/2.0)
		position = originalPos + deltaPos*progress
		sprite.modulate.a = (1 - a_progress)
		
		elapsed += lastDelta
		await get_tree().create_timer(lastDelta).timeout
	connectedMon.battleController.dashParticles.emitting = false
	
	
	
	sprite.modulate.a = 0
	elapsed = 0
	connectedMon.battleController.dashParticles.position = originalPos + deltaPos*(1 - dashFraction)
	await get_tree().create_timer(0.05).timeout
	connectedMon.battleController.createImpact(originalPos + deltaPos + Vector3(0.2, 0.5, 0.1))
	contactReturn(timeMax, originalPos, deltaPos, dashFraction)
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reloadMonster()
	playerControlled = get_meta("playerControlled")
	#generate the bobbing offset
	randOffset = rng.randf_range(0, 20)

# Returns negative for even values of x and positive of odd values of x
func posOddNegEven(x) -> int:
	if x%2 == 0:
		return -1
	else:
		return 1


var xScaling = 0.5
# Returns intended position of monster (using its teamID and designation as a player/enemy monster)
func getMonsterPosition() -> Vector3:
	#base position for a player controlled monster
	var positionIndex = ceil(teamID/2.0)
	var deltaZ = -posOddNegEven(teamID)*0.5*positionIndex*xScaling
	var evenBonus = 0
	var backBonus = 0
	if teamID%2 == 0:
		evenBonus = 0.3
	if teamID > 0:
		backBonus = 1
	var pos = Vector3(-2 - backBonus - positionIndex*(1.5 + evenBonus) + deltaZ/1.3, 0, 0.25 + deltaZ)
	pos.x *= xScaling
	if !playerControlled:
		#flip the position across the origin if its an enemy monster
		pos.x *= -1
	return pos

func jumpToPosition(pos: Vector3, delta) -> void:
	
	var initial: Vector3 = position
	var elapsed = 0
	var timeMax = ceil((pos - initial).length())/15
	var yVertex = 1
	while elapsed < timeMax:
		var progress = elapsed/timeMax
		var posX: float = initial.x + (pos.x - initial.x)*progress
		var posY: float = initial.y + -(progress)*(progress - 1)*yVertex
		var posZ: float = initial.z + (pos.z - initial.z)*progress
		position = Vector3(posX, posY, posZ)
		elapsed += delta/4
		bobAddition = -10*(progress)*(progress - 1)
		await get_tree().create_timer(delta/10).timeout
	bobAddition = 0
	position = pos
	jumping = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lastDelta = delta
	#calculate and set the monster position to the intended position
	if lockToIntendedPosition:
		var intendedPosition: Vector3 =  getMonsterPosition()
		if (intendedPosition - position).length() > 0.2 && !jumping:
			jumping = true
			jumpToPosition(intendedPosition, delta)
	#check if KO'd
	if connectedMon.isKO():
		#run KO animation
		faintAnimation(delta)
	
	
	
	#calculate the delta for the bobbing
	var bobDelta = idleStrength*(sin(t*2 + randOffset) + bobAddition)
	
	if playerControlled:
		#if monster is player controlled, rotate the sprite 180 degrees
		sprite.rotation_degrees = Vector3(0, 180, 0)
	else:
		#if the monster is enemy controlled, no sprite rotation is needed
		sprite.rotation_degrees = Vector3(0, 0, 0)
	
	
	#change the scale of the sprite to simulate bobbing
	sprite.scale = bobMultiplier*Vector3(1, (1 - idleStrength) + bobDelta,  1)
	#to anchor it at the bottom, add (delta - max)/2 to the position of the **sprite** (not actual monster)
	var img: Texture2D = sprite.texture 
	var h = img.get_height()*sprite.pixel_size

	sprite.offset = monsterData.battleOffset
	sprite.position = Vector3(0, (bobDelta - idleStrength)/2 + bobMultiplier*h/2, 0)
	
	#manage shield particles
	shieldParticles.emitting = connectedMon != null && !connectedMon.isKO() && connectedMon.shield > 0
	shieldParticles.amount_ratio = max(0.15, (1.0*connectedMon.shield)/connectedMon.maxHP); #30 is a good looking amount
	empowerParticles.emitting = connectedMon != null && !connectedMon.isKO() && connectedMon.hasStatus(Status.EFFECTS.EMPOWER_PLAYED)
	
	if lockToIntendedPosition:
		var targetColor = Color.WHITE
		if connectedMon.hasStatus(Status.EFFECTS.OVERHEAT):
			targetColor = lerp(targetColor,Color.DIM_GRAY, 0.5)
		elif connectedMon.hasStatus(Status.EFFECTS.BURN):
			targetColor = lerp(targetColor,Color.RED, 0.1)
		elif connectedMon.hasStatus(Status.EFFECTS.POISON):
			targetColor = lerp(targetColor,Color.PURPLE, 0.1)
		elif connectedMon.hasStatus(Status.EFFECTS.PRIORITY):
			targetColor = lerp(targetColor,Color.YELLOW, 0.2)
		
		sprite.modulate = lerp(sprite.modulate, targetColor, delta*4)
	#update the total time by adding the delta time to the tracker
	t += delta
