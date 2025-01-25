extends Card

#THIS IS AN EXAMPLE CARD WITH A BASIC GUIDE TO MAKING CARDS
func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "100% Attack."
	name = "Strike"
	
	power = 1 #set the default power of attacking moves
	shieldPower = 0.8 #set the default power of defending moves

func effect(attacker: BattleMonster, defender: BattleMonster):
	#DEALING DAMAGE
	await dealDamage(attacker, defender) #attack using default power (with empower)
	await dealDamage(attacker, defender, 1.7) #attack using an explicitly defined power (170% in this case) (with empower)
	await dealDamage(attacker, defender, power, false) #attack while ignoring the boost from empower
	defender.receiveDamage(10,attacker) #deal set damage to a monster
	defender.trueDamage(10) #deal set damage to monster while ignoring shield
	
	#DEFENDING
	await giveShield(attacker, defender) #defend using default shield power (with empower)
	await giveShield(attacker, defender, 1.9) #defend using an explicitly defined power (190% in this case) (with empower)
	await giveShield(attacker, defender, shieldPower, false) #defend while ignoring the boost from empower
	attacker.addShield(10) #add set shield to a monster
	
	#ADDING STATUS
	var statusObject = Status.new(Status.EFFECTS.HASTE,2) #status object with a numerical modifier (Haste 2 in this case)
	statusObject = Status.new(Status.EFFECTS.CANT_PLAY) #status object without numerical modifiers (Can't Play in this case)
	attacker.addStatusCondition(statusObject) #add status to monster (can be the defender too)
	var hasEmpower = attacker.hasStatus(Status.EFFECTS.EMPOWER_PLAYED) #check if attacker has status of a specific type
	var empowerObject = attacker.getStatus(Status.EFFECTS.EMPOWER_PLAYED) #get status object with a specific type
	#for more information on status objects, look in status.gd
	
	#RECKLESS
	await applyReckless(attacker, defender) #run reckless sequence
	if (await applyReckless(attacker, defender)): #run reckless sequence and check if card satisfies meetsRequirement function
		pass #to see more in depth examples of reckless, check any FND-JU-*** card script
	
	#Miscellaneous modifiers
	attacker.addMP(2) #instantly add MP to a monster's team
	defender.addHP(2) #instantly add HP to a monster
	attacker.setAttack(0) #set the raw attack stat of a monster
	defender.addAttackBonus(0.75) #add percentage attack bonus (in decimal) to a monster
	attacker.drawCards(3) #draw cards to a monster's hand
	
	#Global modifiers
	attacker.battleController.playerMPGain = 4 #overwrite the base mp gain per turn for the player team
	attacker.battleController.enemyMPGain = 4 #overwrite the base mp gain per turn for the enemy team
	attacker.battleController.playerMPTempGain #set the additional player mp gain for the next turn (resets to 0 right after)
	attacker.battleController.enemyMPTempGain #set the additional enemy mp gain for the next turn (resets to 0 right after)
	
	#MATH
	var dmg = _calcPower(attacker,defender,power,true) #calculate current damage of the card on a **defender**
	var shield = _calcShield(attacker,defender,shieldPower,false) #calculate current shield of a card on an **attacker**
	
