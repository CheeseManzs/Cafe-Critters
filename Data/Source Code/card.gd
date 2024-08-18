class_name Card
extends Resource

#list of god alignments
enum ALIGNMENT {
	Default,
	Mise,
	Scythanna,
	Anvi,
	Secs,
	Eco,
	Jacks
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

#cost of card
var cost: int
#priority of card
var priority: int
#god alignment of card
var alignment: ALIGNMENT
#role of card
var role: ROLE
#card desc
var description: String
#card name
var name: String

var statusConditions: Array[Status.EFFECTS] = []

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 0

func clone():
	var newCard: Card = get_script().new()
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
