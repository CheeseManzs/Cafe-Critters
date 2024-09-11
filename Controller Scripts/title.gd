extends Node2D

@export var debugTeamA: Array[Monster]
@export var debugTeamB: Array[Monster]
@export var debugPersonality: AIPersonality

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(debugTeamB)
	if LoadManager.activeScene == null:
		LoadManager.activeScene = get_tree().current_scene
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func loadScene(sceneName: String) -> void:
	if sceneName == "Battle":
		
		BattleController.startBattle(debugTeamA, debugTeamB, debugPersonality)
		return
	LoadManager.loadScene(sceneName)
	pass # Replace with function body.
