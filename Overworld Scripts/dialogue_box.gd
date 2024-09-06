extends Panel
var timer = 0
var speed = 3
var isOpening = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anchor_top = 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isOpening == true:
		timer += delta * speed
		if timer > 1: timer = 1
	else:
		timer -= delta * speed
		if timer < 0: timer = 0
	
	var processVal = sin(PI * timer / 2)
	anchor_top = 1 - (0.4 * timer)
	pass


func _on_player_dialogue_opened() -> void:
	isOpening = true
	#anchor_top = 0.6
	pass # Replace with function body.
