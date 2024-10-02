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
@export var alignment: ALIGNMENT
@export var role: ROLE
@export var dexEntry: String
@export var sprite: Texture
@export var passive: PassiveAbility
@export var deck: Zone

# variables related to what cards they have and gain access to.
@export var startingCardPool: Zone
@export var levelupCards: Array[Zone]

# strings that store info about their stat growth curves.
@export var rawHealth: String
@export var rawAttack: String
@export var rawDefense: String
@export var levelingType: String
@export var levelingItems: Array[String]

# Depreciated
@export var statHealth: Array
@export var statAttack: Array
@export var statDefense: Array

# level
@export var level: int

@export var battleOffset: Vector2

var StatCurves: Dictionary = {
	"growth40": [40, 46, 52, 58, 65, 71, 79, 86, 93, 100],
	"growth15": [15, 16, 18, 19, 21, 22, 24, 26, 28, 30],
	"growth12": [12, 13, 14, 16, 17, 19, 20, 22, 23, 24]
}

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
			p_statHealth = [1], p_statDefense = [1], p_statAttack = [1],
			p_level = 0, rawH = "growth40", rawA = "growth40", rawD = "growth40"):
	id = p_id
	name = p_name
	sprite = p_sprite
	deck = p_deck
	startingCardPool = p_startingCardPool
	statHealth = p_statHealth
	statDefense = p_statDefense
	statAttack = p_statAttack
	level = p_level
	rawHealth = rawH
	rawAttack = rawA
	rawDefense = rawD
	
func getHealth(inputLevel = level): 
	return StatCurves[rawHealth][inputLevel]
	
func getDefense(inputLevel = level): 
	return StatCurves[rawDefense][inputLevel]
	
func getAttack(inputLevel = level): 
	return StatCurves[rawAttack][inputLevel]
	
