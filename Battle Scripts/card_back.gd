class_name CardBack
extends Control

var currentTarg: Vector2 = Vector2(0, 500)
var targetPos: Vector2 = Vector2(0, 0)
var overwrite = false
var overwritePos: Vector2
var removing = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = (10.0*randf() - 5.0)*(PI/180.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	size = Vector2(720, 1000)
	if overwrite:
		targetPos = overwritePos
	currentTarg = currentTarg + (targetPos - currentTarg)*delta*4
	position = currentTarg - size/2
	pass

func queue_des():
	while (overwritePos - currentTarg).length() > 0.5:
		await get_tree().create_timer(0.01).timeout
	self.queue_free()

func destroy():
	overwrite = true
	removing = true
	overwritePos = Vector2(0, 500)
	queue_des()
	await get_tree().create_timer(0.1).timeout
	return
	
