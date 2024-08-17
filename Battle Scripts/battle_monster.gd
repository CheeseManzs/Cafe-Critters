class_name BattleMonster

#link to raw monster data
@export var rawData: Monster
#current deck of the monster
@export var currentDeck: Zone
#current hand of the monster/player
@export var currentHand: Zone
#current level of the monster
@export var level: int
#current health of the monster
@export var health: int
#monster's current Max HP stat
@export var maxHP: int
#monster's current defense stat
@export var defense: int
#monster's current attack stat
@export var attack: int
#monster's current shield
@export var shield: int
#battle controller that instantiated the monster
var battleController: BattleController
var playerControlled: bool

func _init(data: Monster, controller: BattleController = null, p_playerControlled = true) -> void:
	#set raw data
	rawData = data
	#set the controller
	battleController = controller
	#copy data for raw data
	level = 1
	shield = 0
	maxHP = rawData.statHealth
	health = maxHP
	defense = rawData.statDefense
	attack = rawData.statAttack
	currentDeck = rawData.deck.clone()
	playerControlled = p_playerControlled
	hardReset()
	

#applies damage to shield and returns overdamage
func damageShield(depletionAmount: int) -> int:
	#remove damage from shield
	shield -= depletionAmount
	#if shield takes more damage than it has, it is considered overdamage
	if shield < 0:
		#overdamage is the negative of the remaining shield
		var overdamage = -shield
		#reset shield
		shield = 0
		return overdamage
	return 0

#reset that happens on switch-in
func hardReset() -> void:
	shield = 0
	currentHand = Zone.new()
	currentHand.storedCards = currentDeck.bulkDraw(5)

# Resets values for the start of a turn
func reset(active = true) -> void:
	shield = 0
	if active && len(currentDeck.storedCards) == 0:
		BattleLog.singleton.log("DEBUG: Resetting deck")
		currentDeck = rawData.deck.clone()
	
	if active && len(currentDeck.storedCards) > 0 && len(currentHand.storedCards) < 5:
		var card: Array[Card] = currentDeck.bulkDraw(1)
		BattleLog.singleton.log("DEBUG: " + rawData.name + " drew " + card[0].name)
		currentHand.storedCards += card

#adds to monster's shield
func addShield(shieldAmount: int) -> void:
	shield += shieldAmount
	BattleLog.singleton.log(rawData.name + " gained " + str(shieldAmount) + " shield")
	if shield < 0:
		shield = 0
#does pure damage to the monster
func trueDamage(dmg: int) -> void:
	#remove damage from hp
	health -= dmg
	BattleLog.singleton.log(rawData.name + " took " + str(dmg) + " damage")
	#health cannot be negative
	if health <= 0:
		health = 0

#applies general damage
func receiveDamage(dmg:int, attacker: BattleMonster) -> int:
	#damage shield and calculate overdamage
	var pureDmg = damageShield(dmg)
	#apply overdamage to monster as true damage
	trueDamage(pureDmg)	
	return pureDmg

#adds mp to the monster's team
func addMP(mpAmount: int) -> void:
	BattleLog.singleton.log(rawData.name + "'s team gained " + str(mpAmount) + " MP")
	if playerControlled:
		battleController.playerMP += mpAmount
	else:
		battleController.enemyMP += mpAmount
	
