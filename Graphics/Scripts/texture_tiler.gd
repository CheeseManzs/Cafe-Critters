extends MeshInstance3D

func _ready() -> void:
	var mat: BaseMaterial3D = material_override
	mat.uv1_scale = mesh.get_aabb().size#Util.abstractVector3ByElement(mesh.get_aabb().size, Util.reciprocal)
