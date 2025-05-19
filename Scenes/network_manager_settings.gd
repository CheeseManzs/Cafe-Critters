extends Node
class_name NetworkManagerSettings

@export var ipDisplay: Button
@export var ipText: TextEdit
@export var teamText: TextEdit
@export var teamPacker: MonsterCache
@export var debugManager: DebugGameManager
@export var lockedButtons: Array[Button]
@export var defaultPersonality: AIPersonality
@export_multiline var defaultTeam: String

func _ready():
	ConnectionManager.singleton.setSettings(self)

func _on_online_battle_host_pressed() -> void:
	ConnectionManager.singleton._on_online_battle_host_pressed()
	


func _on_online_battle_join_pressed() -> void:
	ConnectionManager.singleton._on_online_battle_join_pressed()
