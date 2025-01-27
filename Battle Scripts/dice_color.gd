class_name DiceColor
extends Node3D

var indentColor: Color
@export var meshObj: MeshInstance3D 
var mat: StandardMaterial3D
var mat2: StandardMaterial3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	indentColor = Color.BLACK
	mat = meshObj.get_surface_override_material(1).duplicate()
	meshObj.set_surface_override_material(1,null)
	meshObj.set_surface_override_material(1,mat)
	mat2 = meshObj.get_surface_override_material(2).duplicate()
	meshObj.set_surface_override_material(2,null)
	meshObj.set_surface_override_material(2,mat2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mat.emission = indentColor
	mat2.emission = indentColor
	pass
