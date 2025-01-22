class_name Card
extends Resource

#list of god alignments
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
	Generic,
	Point,
	Payoff,
	Support,
	Unique,
	Token
}

enum RARITY {
	Common,
	Uncommon,
	Rare,
	Epic,
	Legendary
}


#cost of card
var cost: int
#priority of card
var priority: int
#god alignment of card
var alignment: ALIGNMENT
#role of card
var role
#card desc
var description: String
#card name
var name: String
#card rarity
var rarity: RARITY

var statusConditions: Array[Status.EFFECTS] = []

@export var aiDetails: AIInfo
@export var art: Texture2D

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 0

#for ai damage calculations
func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 0

#for ai damage calculations
func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 0

#for ai damage calculations
func calcBonus(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 0

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null

#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null

#checks what status will be removed from the user
func calcStatusCured(attacker: BattleMonster, defender: BattleMonster) -> Status.EFFECTS:
	return Status.EFFECTS.NONE

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	return true

func clone():
	var newCard: Card = get_script().new()
	newCard.art = art
	newCard.cost = cost
	newCard.priority = priority
	newCard.alignment = alignment
	newCard.role = role
	newCard.description = description
	newCard.name = name
	newCard.statusConditions = []
	if statusConditions != null:
		newCard.statusConditions += statusConditions
	return newCard
