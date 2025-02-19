class_name BattleCamera
extends Camera3D


@export var moveParticles: GPUParticles3D
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
static var singleton: BattleCamera
var ogPos: Vector3
var focusPos: Vector3
var focusOffset: Vector3 = Vector3.ZERO
var focusZoom = 1
var focusTargetPos: Vector3
var ogDistance
var shaking = false
var focusing = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ogPos = position
	singleton = self
	position.y += 30
	ogDistance = (position - ogPos).length()
	pass # Replace with function body.

func randomOffset(range: float) -> Vector3:
	return Vector3(
		rng.randf_range(-range, range),
		rng.randf_range(-range, range),
		0
	)

func focusMonster(mon: BattleMonster, _zoom = 1.5, _yweight = 1.0):
	await  focusMonsters([mon],_zoom,_yweight)
	
func focusMonsters(mons: Array, _zoom = 1.5,_yweight = 1.0):
	
	if len(mons) == 0:
		return
	focusZoom = _zoom
	var activeMon = mons[0].battleController.getActivePlayerMon()
	var activeOpp = mons[0].battleController.getActiveEnemyMon()		
	if focusOffset == Vector3.ZERO:
		focusOffset = global_position - (activeMon.getMonsterDisplay().global_position + activeOpp.getMonsterDisplay().global_position)/2.0
		
	var averagePosition: Vector3 = Vector3.ZERO
	for mon in mons:
		averagePosition += mon.getMonsterDisplay().global_position + _yweight*Vector3.UP*mon.getMonsterDisplay().getHeight()/4.0
	focusPos = averagePosition/float(len(mons))
	focusTargetPos = focusPos + focusOffset*(1.0/focusZoom)
	focusing = true
	while (global_position - focusTargetPos).length() > 0.1:
		await get_tree().process_frame
	return

func disableFocus():
	focusing = false

func shake(shakeStrength: float = 0.1) -> void:
	
	shaking = true
	var strength = shakeStrength
	var originalPos = position
	for i in 50:
		var off = randomOffset(strength)
		strength *= 0.92
		h_offset = off.x
		v_offset = off.y
		position = originalPos
		await get_tree().create_timer(0.01).timeout
	position = originalPos
	shaking = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cutoff = 0.03
	if !shaking && !focusing:
		position = lerp(position, ogPos,delta*4)
		moveParticles.amount_ratio = max(0,(position - ogPos).length()/ogDistance-cutoff)
	elif !shaking && focusing:
		focusTargetPos = focusPos + focusOffset*(1.0/focusZoom)
		global_position = lerp(global_position, focusTargetPos,delta*4)
	
	if (position - ogPos).length()/ogDistance <= cutoff:
		moveParticles.emitting = false
