class_name BattleCamera
extends Camera3D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
static var singleton: BattleCamera
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	singleton = self
	pass # Replace with function body.

func randomOffset(range: float) -> Vector3:
	return Vector3(
		rng.randf_range(-range, range),
		rng.randf_range(-range, range),
		0
	)

func shake(shakeStrength: float = 0.1) -> void:
	
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
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
