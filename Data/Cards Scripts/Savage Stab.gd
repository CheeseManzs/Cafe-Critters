extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = ROLE.Unique
	description = "Reckless. 125% Attack."
	name = "Oops!"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	var attackPower = 0
	var discardedCard = attacker.discardRandomCard()
	if discardedCard == null:
		BattleLog.singleton.log("No card to discard...")
		return 0

	attackPower = 1.25*attacker.getAttack()
	
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	#deal damage
	defender.receiveDamage(attackPower, attacker)
	return attackPower

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var attackPower = 0
	attackPower = 1.25*attacker.getAttack()
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	return attackPower
