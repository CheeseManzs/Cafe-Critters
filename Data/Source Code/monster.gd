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
	Blanc
}

#list of roles
enum ROLE {
	Point,
	Payoff,
	Support
}

@export var id: int
@export var name: String
@export var alignment: ALIGNMENT
@export var role: ROLE
@export var dexEntry: String
@export var sprite: Texture
@export var passive: PassiveAbility
@export var deck: Zone

@export var startingCardPool: Zone
@export var levelupCards: Array[Zone]

@export var rawHealth: String
@export var rawAttack: String
@export var rawDefense: String

@export var statHealth: Array
@export var statAttack: Array
@export var statDefense: Array

@export var level: int

@export var battleOffset: Vector2

var StatCurves = {
	"growth40": [40, 46, 52, 58, 65, 71, 79, 86, 93, 100],
	"growth15": [15, 16, 18, 19, 21, 22, 24, 26, 28, 30],
	"growth12": [12, 13, 14, 16, 17, 19, 20, 22, 23, 24]
}

func _init(p_id = 0, p_name = "null", p_sprite = null, p_deck = null, p_startingCardPool = null, 
			p_statHealth = [1], p_statDefense = [1], p_statAttack = [1],
			p_level = 0):
	id = p_id
	name = p_name
	sprite = p_sprite
	deck = p_deck
	startingCardPool = p_startingCardPool
	statHealth = p_statHealth
	statDefense = p_statDefense
	statAttack = p_statAttack
	level = p_level
	
func getHealth(): 
	return StatCurves[rawHealth][level]
	
func getDefense(): 
	return StatCurves[rawDefense][level]
	
func getAttack(): 
	return StatCurves[rawAttack][level]
	
