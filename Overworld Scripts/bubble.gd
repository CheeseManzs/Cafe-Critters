extends Sprite3D
var timer = 0
var isSpawning = true
var startPosition: Vector3
var speed = 6

func spawnAnim(startLoc: Vector3) -> void:
	position = startLoc
	scale = Vector3(0, 0, 0)
	isSpawning = true
	startPosition = startLoc
	pass

func despawnAnim() -> void:
	isSpawning = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isSpawning == true:
		timer += delta * speed
		if timer > 1: timer = 1
	else:
		timer -= delta * speed
		if timer < 0: timer = 0
	
	var processVal = sin(PI * timer / 2)
	#var processVal = timer
	
	scale = Vector3(1, 1, 1) * processVal * 2
	position.y = startPosition.y + processVal * 0.5
	
	if isSpawning == false and timer == 0:
		queue_free()
	pass
