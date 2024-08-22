class_name DamagePopup
extends Node3D

@export var label: Label3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func setDamage(dmg: int, scaleMod: float = 1):
	label.text = str(dmg)
	scale = Vector3(2,2,2)*scaleMod

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector3(0, delta, 0)
	var currentCol = label.modulate
	if currentCol.a > 0:
		label.modulate = Color(currentCol.r,currentCol.g,currentCol.b,currentCol.a - delta*2)
	else:
		queue_free()
	pass
