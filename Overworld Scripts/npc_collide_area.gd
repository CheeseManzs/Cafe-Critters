extends Area3D
var areaName = "NPC"
var target_velocity = Vector3.ZERO
var stored_dir = 0
@export var speechBubble: PackedScene = load("res://Prefabs/bubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _physics_process(delta: float) -> void:
	pass
