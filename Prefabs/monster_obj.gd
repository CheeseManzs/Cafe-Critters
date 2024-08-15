extends Node3D

var t = 0.0
var monsterData: Resource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monsterData = get_meta("Monster_Data")
	print(monsterData)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(delta) 
	$Sprite3D.texture = monsterData.sprite
	t += delta
	print(t)
	pass
