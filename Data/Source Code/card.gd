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

var power: float = 0
var shieldPower: float = 0

var statusConditions: Array[Status.EFFECTS] = []
var tags: Array[String] = []

@export var aiDetails: AIInfo
@export var art: Texture2D

func effect(attacker: BattleMonster, defender: BattleMonster):
	return 0

#deal damage
func dealDamage(attacker: BattleMonster, defender: BattleMonster, _power: float = power, applyEmpower = true) -> int:
	var dmg = _calcPower(attacker, defender, _power, applyEmpower)
	await defender.receiveDamage(dmg, attacker)
	return dmg

#give shield
func giveShield(attacker: BattleMonster, defender: BattleMonster, _sp: float = shieldPower, applyEmpower = true):
	var shield = _calcShield(attacker, defender, _sp, applyEmpower)
	await defender.addShield(shield)

#give status
func giveStatus(target: BattleMonster, effect: Status.EFFECTS, X: float = 0, Y: float = 0, broadcast = true, applyEmpower = true):
	var proc_X = X
	var proc_Y = Y
	if statusConditions.has(Status.EFFECTS.EMPOWER) && applyEmpower:
		proc_X = ceil(proc_X*1.5)
		proc_Y = ceil(proc_Y*1.5)
	await target.addStatusCondition(Status.new(effect, proc_X, proc_Y),broadcast)
#quick shortcut
func giveStatus_noempower(target: BattleMonster, effect: Status.EFFECTS, X: float = 0, Y: float = 0, broadcast = true):
	giveStatus(target, effect, X, Y,broadcast, false)

#for dynamic damage calculations
func _calcPower(attacker: BattleMonster, defender: BattleMonster, _power: float, applyEmpower = true) -> int:
	var dmg = ceil(_power*attacker.getAttack())
	if statusConditions.has(Status.EFFECTS.EMPOWER) && applyEmpower:
		dmg = ceil(dmg*1.5)
	return dmg

#for dynamic shield calculations
func _calcShield(attacker: BattleMonster, defender: BattleMonster, _sp: float, applyEmpower = true) -> int:
	var shield = ceil(_sp*attacker.getDefense())
	if statusConditions.has(Status.EFFECTS.EMPOWER) && applyEmpower:
		shield = ceil(shield*1.5)
	return shield

#for ai damage calculations
func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	return _calcPower(attacker, defender, power)

#for ai damage calculations
func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	return _calcShield(attacker, defender, shieldPower)

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

#utility functions
func applyReckless(attacker: BattleMonster, defender: BattleMonster):
	await EffectFlair.singleton._runFlair("Reckless")
	#add reckless status
	var recklessStatus: Status = Status.new(Status.EFFECTS.RECKLESS,1,0)
	attacker.addStatusCondition(recklessStatus)
	
	var discardedCard = await attacker.discardRandomCard()
	
	if discardedCard == null:
		BattleLog.singleton.log("No card to discard...")
	
	return discardedCard != null && meetsRequirement(discardedCard, attacker, defender)

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
