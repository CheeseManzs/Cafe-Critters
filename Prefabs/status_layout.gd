extends Node3D
class_name StatusLayout

var statusArray: Array[Status] = []
@export var monsterObject: MonsterDisplay

func removeChildren():
	for _node in get_children():
		_node.queue_free()
	while get_child_count() > 0:
		await get_tree().create_timer(0.1).timeout

func getChildPosition(childIndex: int, childCount: int):
	var childDistance: Vector3 = Vector3(0.5, 0, 0)
	var scaler: float = childIndex - float(childCount - 1)/2
	return global_position + childDistance*scaler

func delyedRealign(waitForDeath: Node):
	while waitForDeath:
		await get_tree().create_timer(0.1).timeout
	realign()

func realign():
	var children = get_children()
	var totalCount = len(children)
	var index = 0
	for _node in get_children():
		var node: Node3D = _node
		node.target_position = getChildPosition(index, totalCount) - global_position
		if !node.setPosition:
			node.setPosition = true
			node.position = node.target_position
		index += 1
