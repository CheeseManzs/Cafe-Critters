extends TextureRect
var timer = 0
var speed = 3
var isOpening = false
var currentScript: ZDialog
var currentLine = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anchor_right = -0.5
	anchor_left = -1.5
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
	anchor_left = -1.5 + processVal
	anchor_right = -0.5 + processVal
	
	pass


func _on_player_dialogue_opened(dLine: ZDialog) -> void:
	isOpening = true
	#anchor_right = 0.3
	pass # Replace with function body.


func _on_player_dialogue_closed() -> void:
	pass # Replace with function body.


func _on_player_dialogue_passed() -> void:
	pass # Replace with function body.
