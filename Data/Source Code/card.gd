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
	Blanc,
}

static var alignmentToString = {
	ALIGNMENT.Default: "Default",
	ALIGNMENT.Mise: "Mise",
	ALIGNMENT.Rea: "Rea",
	ALIGNMENT.Anvi: "Anvi",
	ALIGNMENT.Sec: "Sec",
	ALIGNMENT.Eco: "Eco",
	ALIGNMENT.Jacks: "Jacks",
	ALIGNMENT.Blanc: "Blanc"
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

static var tooltipColors = {
	"ATK":"77130e",
	"DEF":"7FFFD4",
	"KEY":"gold"
}

static var alignemColors = {
	ALIGNMENT.Default: "ffffff",
	ALIGNMENT.Mise:"79c3ed",
	ALIGNMENT.Rea:"d197f0",
	ALIGNMENT.Anvi:"e89420",
	ALIGNMENT.Sec:"f5e07a",
	ALIGNMENT.Eco:"9dfc74",
	ALIGNMENT.Jacks:"#fa8282",
	ALIGNMENT.Blanc:"c9c9c7",
}

func descAttackCalc(attacker: BattleMonster, defender: BattleMonster, atkNum: float):
	return _calcPower(attacker, defender, atkNum/100.0)

func descShieldCalc(attacker: BattleMonster, defender: BattleMonster, atkNum: float):
	return _calcShield(attacker, defender, atkNum/100.0)

var hintStats: Dictionary[String, Callable] = {
	"ATK": descAttackCalc,
	"DEF": descShieldCalc
}

#cost of card
var cost: int
#cost the card was played with
var playedCost: int
#additive cost modifier
var costMod: int 
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
var originator: BattleMonster = null #the monster that owns this card
var selfTarget: bool = false
var salvaged: bool = false

@export var art: Texture2D



func getSurroundingWord(s: String, index, spaceCount = 0):
	var left = index
	var right = index
	var maxSpaces = spaceCount
	var rightSpaces = maxSpaces
	
	while left > 0 && s[left] != " ":
		left = left - 1
	
	while right < len(s) && rightSpaces >= 0:
		if s[right] == " ":
			rightSpaces -= 1
		if rightSpaces < 0:
			break
		right = right + 1
	print("left:",left," right:",right)
	print(s, " l:", left, " r-l:",right - left)
	return s.substr(left, right - left)

func getSurroundingHint(s: String, index, spaceCount = 0):
	var left = index
	var right = index
	var maxSpaces = spaceCount
	var rightSpaces = maxSpaces
	
	while left > 0 && s[left] != "(":
		left = left - 1
	
	while right < len(s) && rightSpaces >= 0:
		if s[right] == ")":
			rightSpaces -= 1
		if rightSpaces < 0:
			break
		right = right + 1
	print("left:",left," right:",right)
	print(s, " l:", left, " r-l:",right - left)
	return s.substr(left, right + 1 - left)
	
func getRealCost() -> int:
	return max(0, cost + getCostMod())

func getCostMod() -> int:
	return costMod

func effect(attacker: BattleMonster, defender: BattleMonster):
	return 0

func localSwap(old: BattleMonster, new: BattleMonster):
	if old.playerControlled:
		await old.battleController.playerSwap(old.battleController.playerTeam.find(new))
	else:
		await old.battleController.enemySwap(old.battleController.enemyTeam.find(new))

#deal damage
func dealDamage(attacker: BattleMonster, defender: BattleMonster, _power: float = power, applyEmpower = true) -> int:
	var dmg = _calcPower(attacker, defender, _power, applyEmpower)
	var pureDmg = await defender.receiveDamage(dmg, attacker)
	return pureDmg

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

static func rollDice(roller: BattleMonster):
	var rolledNum = await Dice.singleton.roll()
	BattleLog.singleton.log(roller.rawData.name + " rolled a " + str(rolledNum)+"!")
	var transformedNum = roller.getPassive().diceTransform(roller, roller.battleController, rolledNum)
	if transformedNum != rolledNum:
		await roller.getPassive().createFlair(roller)
		BattleLog.singleton.log(roller.rawData.name + " turned the " + str(rolledNum) + " into a " + str(transformedNum) + "!")
	return transformedNum

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
	return _calcPower(attacker, defender, power) + omenCalc(attacker, defender)

#for ai damage calculations
func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	return _calcShield(attacker, defender, shieldPower)

#for ai damage calculations
func calcBonus(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 0

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null

func canBePlayed(user: BattleMonster):
	return true

#checks what status will be inflicted on the defender
func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return null

#checks what status will be removed from the user
func calcStatusCured(attacker: BattleMonster, defender: BattleMonster) -> Status.EFFECTS:
	return Status.EFFECTS.NONE

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	return true

func omenCalc(attacker: BattleMonster, defender: BattleMonster):
	var dmg = 0
	if tags.has("Omen") || tags.has("Proc Omen"):
		dmg = _omenCalc(attacker, defender)
	print("found dmg: ", dmg)
	return dmg

#this one doesnt check for the omen tag
func _omenCalc(attacker: BattleMonster, defender: BattleMonster):
	var dmg = 0
	for card in getOmenCards(attacker.battleController):
		print("omen card: ", card.name, " > ", card.originator == attacker)
		if card.originator == attacker:
			card.tags.erase("Omen")
			print("adding: ",card.calcDamage(attacker, defender))
			dmg += ceil(card.calcDamage(attacker, defender))
			card.tags.push_back("Omen")
	return dmg

#utility functions
func applyReckless(attacker: BattleMonster, defender: BattleMonster):
	await EffectFlair.singleton._runFlair("Reckless")
	#add reckless status
	var recklessStatus: Status = Status.new(Status.EFFECTS.RECKLESS,1,0)
	attacker.addStatusCondition(recklessStatus)
	
	var discardedCard = await attacker.discardRandomCard()
	
	if discardedCard == null:
		BattleLog.singleton.log("No card to discard...")
	var meetsConditions = discardedCard != null && meetsRequirement(discardedCard, attacker, defender)
	if meetsConditions:
		await attacker.getPassive().onConditional(attacker, attacker.battleController, self)
	return meetsConditions

func applyOmen(attacker: BattleMonster, defender: BattleMonster):
	if !(tags.has("Omen") || tags.has("Proc Omen")):
		return
	var addBack = []
	var omenCards = getOmenCardsFromMonster(attacker.battleController, attacker)
	if len(omenCards) > 0:
		await EffectFlair.singleton._runFlair("Omen", Color.BLACK)
	for card in omenCards:
		print("omen card: ", card.name,", ",card.originator.playerControlled)
		if card != self:
			if card.statusConditions.has(Status.EFFECTS.EMPOWER):
				card.statusConditions.erase(Status.EFFECTS.EMPOWER)
			BattleLog.singleton.log("Rea used " + card.name + "...")
			await attacker.battleController.get_tree().create_timer(1.0).timeout
			card.tags.erase("Omen")
			await card.effect(attacker, defender)
			card.tags.push_back("Omen")
			addBack.push_back(card)
	#for card in addBack:
		#attacker.battleController.graveyard.erase(card)
		#attacker.currentDeck.storedCards.push_back(addBack)

func descSetup():
	if baseDescription == "null":
		baseDescription = description
	description = baseDescription

func setDescription(attacker: BattleMonster, defender: BattleMonster):
	descSetup()
	genericDescription(attacker, defender)

func genericDescription(attacker: BattleMonster, defender: BattleMonster):
	var replaceBin = []
	var replaceList = []
	
	for statName in hintStats.keys():
		for prefix in ["", "Opponent "]:
			var statInd = "% " + prefix + statName
			var atkDescInd = description.find(statInd)
			var currentAttacker = attacker
			var currentDefender = defender 
			
			if prefix == "Opponent ":
				currentDefender = attacker
				currentAttacker = defender 
			
			print("finding: " + statInd)
			while atkDescInd != -1:
				print("found "+str(statInd)+": " + str(atkDescInd))
				var fullHint = getSurroundingHint(description, atkDescInd)
				var atkNum = int(fullHint)
				var calc = hintStats[statName].call(currentAttacker, currentDefender, atkNum)
				var toReplace = fullHint
				atkDescInd = description.find(statInd, atkDescInd+1)
				if !replaceList.has(toReplace):
					replaceBin.push_back([toReplace,calc, "", tooltipColors[statName],toReplace.replace("(","").replace(")","")])
					replaceList.push_back(toReplace)

	for rawKeywordString in Keyword.keywords:
		var spaces = rawKeywordString.count(" ")
		for ending in ["","."]:
			var keywordString = rawKeywordString + ending
			var atkDescInd = description.find(keywordString)
			while atkDescInd != -1:
				var toReplace = keywordString
				var resetInd = atkDescInd
				print("toReplace: ", "1:",toReplace,"2:",getSurroundingWord(description,resetInd,spaces),"|")
				atkDescInd = description.find(toReplace, atkDescInd+1)
				if !replaceList.has(toReplace) && getSurroundingWord(description,resetInd,spaces).trim_prefix(" ") == toReplace:
					replaceBin.push_back([toReplace,null,toReplace,tooltipColors["KEY"],Keyword.getDescription(rawKeywordString)])
					replaceList.push_back(toReplace)
	
	for rpl in replaceBin:
		
		if rpl[1] == null:
			var tooltip = '[hint="{ratio}"][color={col}]'.format({"ratio": rpl[4], "col": rpl[3]})
			description = description.replace(rpl[0],tooltip+rpl[2]+"[/color][/hint]")
		else:
			var tooltip = '[hint="{ratio}"][color={col}]'.format({"ratio": rpl[4], "col": rpl[3]})
			description = description.replace(rpl[0],tooltip+str(rpl[1])+"[/color][/hint]")

static func getOmenCards(battleController: BattleController):
	return Zone.getTaggedCardsInArray(battleController.graveyard, "Omen")
	
static func getOmenCardsFromMonster(battleController: BattleController, originator: BattleMonster ):
	var omenCards = getOmenCards(battleController)
	var returnArr = []
	for card in omenCards:
		if card.originator == originator:
			returnArr.push_back(card)
	return returnArr
	

static func createInstance(cardName: String):
	var obj: Card = load("res://Data/Cards/"+cardName+".tres")
	return obj.clone()

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
	newCard.costMod = costMod
	if statusConditions != null:
		newCard.statusConditions += statusConditions
	return newCard
