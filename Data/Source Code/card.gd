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
var baseDescription: String = "null"
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



func getSurroundingWord(s: String, index):
	var left = index
	var right = index
	while left > 0 && s[left] != " ":
		left = left - 1
	while right < len(s) && s[right] != " ":
		right = right + 1
	print("left:",left," right:",right)
	return s.substr(left, right - left)
	



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
	await attacker.addShield(shield)

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
	await giveStatus(target, effect, X, Y,broadcast, false)

func rollDice(roller: BattleMonster):
	var rolledNum = await Dice.singleton.roll()
	BattleLog.singleton.log(roller.rawData.name + " rolled a " + str(rolledNum)+"!")
	return rolledNum

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

func setDescription(attacker: BattleMonster, defender: BattleMonster):
	if baseDescription == "null":
		baseDescription = description
	description = baseDescription
	print("base for ",name,": ",baseDescription)
	genericDescription(attacker, defender)

func genericDescription(attacker: BattleMonster, defender: BattleMonster):
	var atkDescInd = description.find("% Attack")
	var replaceBin = []
	var replaceList = []
	while atkDescInd != -1:
		var atkNum = int(getSurroundingWord(description, atkDescInd))
		var calc = _calcPower(attacker, defender, atkNum/100.0)
		var toReplace = str(atkNum) + "% Attack"
		print("DMG of ",name,":",atkNum," ",toReplace)
		atkDescInd = description.find("% Attack", atkDescInd+1)
		if !replaceList.has(toReplace):
			replaceBin.push_back([toReplace,calc, "Damage"])
			replaceList.push_back(toReplace)
	atkDescInd = 0
	while atkDescInd != -1:
		var atkNum = int(getSurroundingWord(description, atkDescInd))
		var calc = _calcShield(attacker, defender, atkNum/100.0)
		var toReplace = str(atkNum) + "% Defend"
		print("DMG of ",name,":",atkNum," ",toReplace)
		atkDescInd = description.find("% Defend", atkDescInd+1)
		if !replaceList.has(toReplace):
			replaceBin.push_back([toReplace,calc,"Block"])
			replaceList.push_back(toReplace)
	
	for rpl in replaceBin:
		var tooltip = "[hint={ratio}][color=7FFFD4]".format({"ratio": rpl[0]})
		description = description.replace(rpl[0],tooltip+str(rpl[1])+" "+rpl[2]+"[/color][/hint]")


func clone():
	var newCard: Card = get_script().new()
	newCard.art = art
	newCard.cost = cost
	newCard.priority = priority
	newCard.alignment = alignment
	newCard.role = role
	newCard.baseDescription = baseDescription
	newCard.description = description
	newCard.name = name
	newCard.statusConditions = []
	if statusConditions != null:
		newCard.statusConditions += statusConditions
	return newCard
