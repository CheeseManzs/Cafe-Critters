extends Control

@export var backdrop: Backdrop
static var bdOverride: Backdrop = null
@export var container: Node3D
var backdropObject: Node3D

func _ready() -> void:
	print("creating bd")
	if bdOverride != null:
		backdrop = bdOverride
	while backdrop == null || container == null:
		print("nulling")
		continue
	print("not null!")
	backdropObject = backdrop.backgroundScene.instantiate()
	backdropObject.scale = Vector3(1,1,1)
	backdropObject.position = Vector3(0, 0, 0)
	print("container: ", container.name)
	self.add_child(backdropObject)
	
