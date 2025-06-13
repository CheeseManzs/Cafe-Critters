class_name HeldItem
extends Resource

static var NONE: HeldItem = HeldItem.new()

enum TIER {
	Mild,
	Balanced,
	Strong,
	Intense,
	Extreme
}

enum SCALETYPE {
	Flat,
	Percent,
	ScalingFlat
}

static var SCALING: Dictionary[TIER, float] = {
	TIER.Mild: 0.25,
	TIER.Balanced: 0.5,
	TIER.Strong: 1,
	TIER.Intense: 1.5,
	TIER.Extreme: 2
}

@export var alignments: Array[Monster.ALIGNMENT]

@export var statWeights: Array[float] = [0, 0, 0, 0] #HP, ATK, DEF, SPE

@export var passive: PassiveAbility

@export var tier: TIER

static func abstractSum(arr: Array):
	var x = arr[0]
	for elementIndex in len(arr):
		if elementIndex > 0:
			x += arr[elementIndex]
	return x

static func abstractScale(arr: Array, scaler: float) -> Array:
	var x = arr.duplicate(true)
	for elementIndex in len(arr):
		x[elementIndex] *= scaler
	return x

static func abstractScaleByElement(arr: Array, scaler: Array) -> Array:
	var x = arr.duplicate(true)
	for elementIndex in len(arr):
		x[elementIndex] *= scaler[elementIndex]
	return x

static func abstractSumByElement(arr: Array, additive: Array) -> Array:
	var x = arr.duplicate(true)
	for elementIndex in len(arr):
		x[elementIndex] += additive[elementIndex]
	return x

static func abstractTransformByElement(arr: Array, T: Callable) -> Array:
	var x = arr.duplicate(true)
	for elementIndex in len(arr):
		x[elementIndex] = T.call(x[elementIndex])
	return x

static func toInt(x) -> int:
	return int(x)

func getBoost(mon: Monster) -> Array[int]:
	var totalLength: float = abstractSum(statWeights)
	if totalLength == 0:
		return [0, 0, 0, 0]
	
	var scaledStats: Array[float] = abstractScale(statWeights, 1.0/totalLength)
	var scalingFactor = SCALING[tier]*mon.level
	
	var continuousScaledStats: Array[float] = abstractScale(scaledStats, scalingFactor)
	var discreteScaledStats: Array[int]
	discreteScaledStats.assign(abstractTransformByElement(continuousScaledStats, toInt))
	
	return discreteScaledStats

func getPassive() -> PassiveAbility:
	return passive

func _init(_alignment: Array[Monster.ALIGNMENT] = [], _statWeights: Array[float] = [0, 0, 0, 0], _passive: PassiveAbility = load("res://Data/Monster Passives/Unremarkable.tres")):
	alignments = _alignment
	statWeights = _statWeights
	passive = _passive
