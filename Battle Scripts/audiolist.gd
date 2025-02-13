extends AudioStreamPlayer

@export var audioList: Array[AudioStream]
@export var autoSet = -1
@export var multiplayerGameIndex = 0
var originalVolume = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	originalVolume = volume_db
	#volume_db = -80
	if BattleController.multiplayer_game:
		autoSet = multiplayerGameIndex
	if autoSet == -1:
		stream = audioList.pick_random()
	else:
		stream = audioList[autoSet]
	play(0.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	volume_db = lerp(volume_db, originalVolume, delta*4)
	pass
