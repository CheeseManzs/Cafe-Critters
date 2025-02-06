class_name BattleCamera
extends Camera3D


@export var moveParticles: GPUParticles3D
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
static var singleton: BattleCamera
var ogPos: Vector3
var ogDistance
var shaking = false
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
	var cutoff = 0.005
	if !shaking:
		position = lerp(position, ogPos,delta*4)
		moveParticles.amount_ratio = max(0,(position - ogPos).length()/ogDistance-cutoff)
	
	if (position - ogPos).length()/ogDistance <= cutoff:
		moveParticles.emitting = false
