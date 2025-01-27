class_name Dice
extends RigidBody3D
@export var rigidbody: RigidBody3D
var rng = RandomNumberGenerator.new()
var detectSide = false
var ogPos: Vector3
var lastDelta: float = 0
static var singleton: Dice = null
@export var diceColor: DiceColor
var timer = 0

#indeex 0 = 1, index 5 = 6
var numKey = [
	[-1,0,0],
	[0,0,1],
	[0,1,0],
	[0,-1,0],
	[0,0,-1],
	[1,0,0]
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	singleton = self
	rigidbody.freeze = true
	global_scale(Vector3(1,1,1)*(0))
	ogPos = global_position
	pass # Replace with function body.

	
#func lerpColor(a: Color,b: Color,t: float):
#	return Color(lerpf(a.r,b.r,t),lerpf())

func roll():
	resetRoll()
	while detectSide:
		await get_tree().process_frame
	var num = getNumber()
	var t = 0
	var oldColor: Color = Color.BLACK
	var newColor: Color = Color.RED
	print("rolling!")
	while t < 1:
		var progress = 2*(1-pow(1-0.5*t,3))
		diceColor.indentColor = lerp(oldColor, newColor, 0.8*progress)
		t += 3*lastDelta
		await get_tree().process_frame 
	t = 0
	while t < 1:
		global_scale(Vector3(1,1,1)*(1-t))
		t += lastDelta
		await get_tree().process_frame 
	global_scale(Vector3(1,1,1)*(0))
	return num  

func resetRoll():
	print("roll!")
	rigidbody.freeze = false
	diceColor.indentColor = Color.BLACK
	global_position = ogPos
	scale = Vector3(1,1,1)*(1)
	rigidbody.linear_velocity = Vector3(rng.randf_range(-1,1),0,-7 + rng.randf_range(-1,1))
	rigidbody.angular_velocity = Vector3(rng.randf_range(-1,1),rng.randf_range(-1,1),rng.randf_range(-1,1))
	timer = 0
	detectSide = true

func smallRange(x: float, y: float):
	return x >= y - 0.5 && x <= y + 0.5

func vectorRange(a: Vector3, b: Vector3):
	return smallRange(a.x,b.x) && smallRange(a.y,b.y) && smallRange(a.z,b.z)

func bigRange(x: float, y: float):
	if x >= 360:
		x -= 360
	if y >= 360:
		y -= 360
	return x >= y - 360 && x <= y + 360

func getNumber() -> int:
	var up: Vector3 = global_transform.basis.y
	for i in range(len(numKey)):
		var vec = Vector3(numKey[i][0],numKey[i][1],numKey[i][2])
		if vectorRange(up,vec):
			
			return i + 1
	return 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lastDelta = delta
	timer += delta
	print(rigidbody.angular_velocity.length(),rigidbody.linear_velocity.length())
	if detectSide && rigidbody.angular_velocity.length() <= 0.001 && rigidbody.linear_velocity.length() <= 0.001 && (getNumber() != 0 || timer > 10):
		rigidbody.freeze = true
		detectSide = false
	pass
