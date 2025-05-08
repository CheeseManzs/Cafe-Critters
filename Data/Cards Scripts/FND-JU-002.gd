extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Hooliquen"
	description = "Reckless > 100% Attack. If Reckless, inflict 10 direct damage to the opponent."
	name = "Oops!"

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	if card.calcDamage(attacker,defender) > attacker.attack:
		return true
	else:
		return false

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	if !(await applyReckless(attacker, defender)):
		BattleLog.singleton.log("Card does not meet requirements...")
		return 0

	var attackPower = 10
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	#deal damage
	await defender.trueDamage(attackPower, attacker)
	return attackPower

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var attackPower = 0
	attackPower = 10
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	return attackPower
