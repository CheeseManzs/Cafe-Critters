extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = ROLE.Unique
	description = "If you were Reckless this turn, draw 2 cards. Attack 25%."
	name = "Non-Pointy End"

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	if card.calcDamage(attacker,defender) > attacker.attack:
		return true
	else:
		return false

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	var attackPower = 0
	attackPower = 0.25*attacker.getAttack()	
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	await defender.receiveDamage(attackPower, attacker)
	
	if !attacker.hasStatus(Status.EFFECTS.RECKLESS):
		BattleLog.singleton.log(attacker.rawData.name + " was not Reckless this turn...")
		return attackPower

	
	#deal damage
	attacker.drawCards(2)
	
	return attackPower

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var attackPower = 0
	attackPower = 0.25*attacker.getAttack()
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	return attackPower
