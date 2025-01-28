class_name HeatGauge
extends TextureRect

@export var progress: float = 0
@export var gaugePivot: Control

var minAngle = 80

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var maxAngle = minAngle
	print(progress)
	gaugePivot.rotation_degrees = lerp(gaugePivot.rotation_degrees,  -minAngle + progress*(maxAngle + minAngle), delta*8)
	pass
