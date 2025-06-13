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
	TIER.Balanced: 0.4,
	TIER.Strong: 0.6,
	TIER.Intense: 0.75,
	TIER.Extreme: 1
}

@export var alignments: Array[Monster.ALIGNMENT]

@export var statWeights: Array[float] = [0, 0, 0, 0] #HP, ATK, DEF, SPE

@export var passive: PassiveAbility

@export var tier: TIER = 0

func getBoost(level: int) -> Array[int]:
	var totalLength: float = Util.abstractSum(statWeights)
	if totalLength == 0:
		return [0, 0, 0, 0]
	
	var scaledStats: Array[float] = Util.abstractScale(statWeights, 1.0/totalLength)
	var scalingFactor = SCALING[tier]*level
	
	var continuousScaledStats: Array[float] = Util.abstractScale(scaledStats, scalingFactor)
	#hp scaling
	continuousScaledStats[0] *= 4
	
	var discreteScaledStats: Array[int]
	
	
	discreteScaledStats.assign(Util.abstractTransformByElement(continuousScaledStats, Util.toInt))
	
	return discreteScaledStats

func toString():
	var _tier = Util.itemTierToString[tier]
	var alignmentArr = []
	for alignment in alignments:
		alignmentArr.push_back(Util.alignmentToString[alignment])
	var _alignments = JSON.stringify(alignmentArr)
	var _statWeights = JSON.stringify(statWeights)
	var _passive = passive.name
	return '{{tier}|{passive}|{alignments}|{statWeights}}'.format({'tier':_tier,'alignments':_alignments,'passive':_passive,'statWeights':_statWeights})

static func fromString(itemString: String, cache: MonsterCache):
	var data = itemString.substr(1,len(itemString)-2).split("|")
	var _alignments: Array[Monster.ALIGNMENT] = []
	for al in JSON.parse_string(data[2]):
		_alignments.push_back(Util.stringToAlignment[al])
	var _passive = cache.getPassiveByName(data[1])
	var _tier = Util.stringToItemTier[data[0]]
	var _statWeights: Array[float]
	_statWeights.assign(JSON.parse_string(data[3]))
	return HeldItem.new(_tier, _alignments,_statWeights,_passive)

func getPassive() -> PassiveAbility:
	return passive

func isNone():
	return (tier == 0) && (passive.name == "Unremarkable") && (len(alignments) == 0) && (Util.abstractSum(statWeights) == 0)

func _init(_tier = 0, _alignment: Array[Monster.ALIGNMENT] = [], _statWeights: Array[float] = [0, 0, 0, 0], _passive: PassiveAbility = load("res://Data/Monster Passives/Unremarkable.tres")):
	tier = _tier
	alignments = _alignment
	statWeights = _statWeights
	passive = _passive
