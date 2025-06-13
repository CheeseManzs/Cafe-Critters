class_name Monster
extends Resource

enum ALIGNMENT {
	Default,
	Mise,
	Rea,
	Anvi,
	Sec,
	Eco,
	Jacks,
	Kress,
	Blanc
}

#list of roles
enum ROLE {
	Point,
	Payoff,
	Support
}

# fixed features of the monster.
@export var id: int
@export var name: String
@export var tags: Array[String]
@export var alignment: ALIGNMENT
@export var role: String
@export var dexEntry: String
@export var sprite: Texture
@export var spriteScale: float = 1
@export var passive: PassiveAbility
@export var heldItem: HeldItem
@export var deck: Zone

# variables related to what cards they have and gain access to.
@export var startingCardPool: Zone
@export var levelupCards: Array[Zone]

# strings that store info about their stat growth curves.
@export var rawHealth: int #Base Health Stat
@export var rawAttack: int #Base Attack Stat
@export var rawDefense: int #Base Defense Stat
@export var rawSpeed: int #Base Speed Stat

@export var levelingType: String
@export var levelingItems: Array[String]

# Depreciated
@export var statHealth: Array
@export var statAttack: Array
@export var statDefense: Array
@export var statSpeed: Array

# level
@export var level: int
static var MAX_LEVEL: int = 50
static var AVG_BASE_STAT: float = 10
static var AVG_MIN_STAT: float = 10
static var AVG_MAX_STAT: float = 100 #50
static var EXPONENTIAL_SCALING: float = 0.963 #0.463

@export var battleOffset: Vector2

static var curveCache = {}

#var StatCurves: Dictionary = {
	#"growth40": [10, 20, 30, 40, 46, 52, 58, 65, 71, 79, 86, 93, 100],
	#"growth20": [5, 10, 15, 20, 21, 22, 24, 26, 28, 30, 33, 36, 40],
	#"growth15": [4, 7, 12, 15, 16, 18, 19, 21, 22, 24, 26, 28, 30],
	#"growth12": [3, 6, 9, 12, 13, 14, 16, 17, 19, 20, 22, 23, 24],
	#"growth8": [2, 4, 6, 8, 9, 10, 11, 12, 13, 14, 16, 17, 18],
	#"growthX": [100, 200, 300, 400, 500, 600, 700 ,800, 900, 1000],
	#"growthXX": [1000, 2000, 3000, 4000, 5000, 6000, 7000 ,8000, 9000, 10000]
#}

static func statFormula(lv, base):
	return pow((float)(lv - 1)/(float)(MAX_LEVEL - 1), EXPONENTIAL_SCALING) * (base/AVG_BASE_STAT) * (AVG_MAX_STAT - AVG_MIN_STAT) + AVG_MIN_STAT

static func generateStatCurve(baseStat) -> Curve:
	if curveCache.has(baseStat):
		return curveCache.get(baseStat)
	var statCurve = Curve.new()
	for i in range(MAX_LEVEL):
		var stat = statFormula(i,baseStat)
		statCurve.add_point(Vector2(i/float(MAX_LEVEL),stat))
	curveCache[baseStat] = statCurve
	return statCurve

# Level costs are an array with multiple layers.
# Layer 1: 9 entries, holds the definitions for each level.
# Layer 2: holds how many unique ingredients are require for each level.
# Layer 3: defines each individual ingredient. [0] is count, [1] is index of levelingItems.
var LevelCosts = {
	"basic": [[ [2, 0] ], [ [3, 0] ], [ [4, 0] ], [ [2, 1], [2, 0] ], [ [3, 1], [3, 0] ],\
			 [ [4, 1], [5, 0] ], [ [2, 2], [3, 1], [3, 0] ], [ [3, 2], [4, 1], [5, 0] ],\
			 [ [4, 2], [5, 1], [8, 0] ]],
	"elemental": [[ [2, 0] ], [ [2, 0], [2, 1] ], [ [3, 0], [3, 1] ], [ [2, 2], [4, 1] ],\
			 [ [3, 2], [2, 3] ], [ [4, 2], [3, 3], [3, 1] ], [ [2, 4], [5, 3], [5, 1] ], \
			 [ [3, 4], [2, 5], [5, 3] ], [ [4, 4], [4, 5] ]],
}

func _init(p_id = 0, p_name = "null", p_sprite = null, p_deck = null, p_startingCardPool = null, 
			p_statHealth = [1], p_statDefense = [1], p_statAttack = [1], p_statSpeed = [1],
			p_level = 0, rawH = 8, rawA = 10, rawD = 10, rawS = 10):
	print("initializing: ",p_name)
	id = p_id
	name = p_name
	sprite = p_sprite
	deck = p_deck
	startingCardPool = p_startingCardPool
	statHealth = p_statHealth
	statDefense = p_statDefense
	statAttack = p_statAttack
	statSpeed = p_statSpeed
	
	level = p_level
	rawHealth = rawH
	rawAttack = rawA
	rawDefense = rawD
	rawSpeed = rawS
	#if deck.storedCards.size() == 0:
	#	deck.storedCards = startingCardPool.storedCards;

static func getStat(inputLevel, growth):
	print("using raw: ", growth)
	print("with lv ", inputLevel, ": sampling at ",inputLevel*1.0/MAX_LEVEL)
	var s = ceil(statFormula(inputLevel, growth))
	print("lv. ",inputLevel," with base ",growth,": ", s)
	return s

func getHeldItem() -> HeldItem:
	if heldItem == null:
		heldItem = HeldItem.new()
	return heldItem

func getHealth(inputLevel = level): 
	return 4*getStat(inputLevel, rawHealth)
	
func getDefense(inputLevel = level): 
	return getStat(inputLevel, rawDefense)
	
func getAttack(inputLevel = level): 
	return getStat(inputLevel, rawAttack)

func getSpeed(inputLevel = level):
	return getStat(inputLevel, rawSpeed)

func getStatArray(inputLevel = level) -> Array:
	return [getHealth(inputLevel), getAttack(inputLevel), getDefense(inputLevel), getSpeed(inputLevel)]
	
