extends Node3D
class_name StatusIcon

@export var statusText: Label3D
@export var filterText: Label3D
@export var spawnAnimationCurve: Curve

var layout: StatusLayout
var maxScale: Vector3
var spawnAnimationTime: float = 0
var deleteAnimationTime: float = 0
static var spawnAnimationLength: float = 0.3
var connectedStatus: Status = null
var done = false
var currentX = 0
var target_position: Vector3
var setPosition = false
func _ready() -> void:
	maxScale = scale
	scale = maxScale*spawnAnimationCurve.sample(0)

func _process(delta: float) -> void:
	
	position = lerp(position, target_position, delta*8)
	
	statusText.modulate.a = layout.monsterObject.sprite.modulate.a
	statusText.outline_modulate.a = layout.monsterObject.sprite.modulate.a
	
	if spawnAnimationTime < spawnAnimationLength:
		scale = maxScale*spawnAnimationCurve.sample(spawnAnimationTime/spawnAnimationLength)
		spawnAnimationTime += delta
	elif spawnAnimationTime > spawnAnimationLength:
		spawnAnimationTime = spawnAnimationLength
		scale = maxScale*spawnAnimationCurve.sample(spawnAnimationTime/spawnAnimationLength)
	if (connectedStatus.effectDone || layout.monsterObject.connectedMon.isKO()) && !done:
		done = true
	if done:
		if deleteAnimationTime >= spawnAnimationLength:
			scale = Vector3.ZERO
			queue_free()
			layout.delyedRealign(self)
		else:
			deleteAnimationTime += delta
			scale = maxScale*spawnAnimationCurve.sample(1 - deleteAnimationTime/spawnAnimationLength)
	
func updateIcon(effect: Status):
	var extension = " " + str(effect.X)
	if effect.X == 0:
		extension = ""
	currentX = effect.X
	effect.icon = self
	statusText.text = effect.toMini() + extension
	
	if len(effect.filter.tagWhiteList) > 0:
		filterText.text = effect.filter.tagAlias[effect.filter.tagWhiteList[0]]
	else:
		filterText.text = ""

func setIcon(effect: Status):
	updateIcon(effect)
	spawnAnimationTime = 0
	connectedStatus = effect

func update(effect: Status):
	if currentX != effect.X:
		setIcon(effect)
