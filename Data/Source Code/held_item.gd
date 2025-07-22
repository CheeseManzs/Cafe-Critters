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
	TIER.Mild: 0.2,
	TIER.Balanced: 0.3,
	TIER.Strong: 0.4,
	TIER.Intense: 0.5,
	TIER.Extreme: 0.75
}

static var SAME_AFFINITY_BONUS = 0.2
static var EXTRA_AFFINITY_PENALTY = 0.1

@export var alignments: Array[Card.ALIGNMENT]

@export var statWeights: Array[float] = [0, 0, 0, 0] #HP, ATK, DEF, SPE

@export var passive: PassiveAbility

@export var tier: TIER = 0

func getBoost(mon: Monster) -> Array[int]:
	var totalLength: float = Util.abstractSum(statWeights)
	if totalLength == 0:
		return [0, 0, 0, 0]
	
	var scaledStats: Array[float] = Util.abstractScale(statWeights, 1.0/totalLength)
	var scalingFactor = SCALING[tier]*mon.level
	
	var continuousScaledStats: Array[float] = Util.abstractScale(scaledStats, scalingFactor)
	
	var percentageBoost = 0
	if mon.alignment in alignments:
		percentageBoost += SAME_AFFINITY_BONUS/len(alignments)
		
	percentageBoost -= max(0, len(alignments) - 2)*EXTRA_AFFINITY_PENALTY
	continuousScaledStats = Util.abstractScale(continuousScaledStats, max(0, 1 + percentageBoost))
	
	#hp scaling
	continuousScaledStats[0] *= 2
	
	
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
	var strippedString = itemString.strip_edges()
	var data = strippedString.substr(1,len(strippedString)-2).split("|")
	var _alignments: Array[Card.ALIGNMENT] = []
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

func _init(_tier = 0, _alignment: Array[Card.ALIGNMENT] = [], _statWeights: Array[float] = [0, 0, 0, 0], _passive: PassiveAbility = load("res://Data/Monster Passives/Unremarkable.tres")):
	tier = _tier
	alignments = _alignment
	statWeights = _statWeights
	passive = _passive
