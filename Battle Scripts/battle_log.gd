class_name BattleLog
extends VBoxContainer
#singleton for ease of use
static var singleton: BattleLog = null
#prefab instantiated on every log
@export var logPrefab: PackedScene

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	singleton = self
	
	pass # Replace with function body.

static func log(text: String) -> void:
	var newLog = singleton.logPrefab.instantiate()
	newLog.logText = text
	singleton.add_child(newLog)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
