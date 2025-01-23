extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = ROLE.Unique
	description = "Reckless > 100% Attack. If Reckless, gain 2 mp. 125% Attack"
	name = "Breakneck Barrage"

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	if card.calcDamage(attacker,defender) > attacker.attack:
		return true
	else:
		return false

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	var attackPower = 0
	attackPower = 1.25*attacker.getAttack()
	
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	#deal damage
	await defender.receiveDamage(attackPower, attacker)
	await EffectFlair.singleton._runFlair("Reckless")
	#add reckless status
	var recklessStatus: Status = Status.new(Status.EFFECTS.RECKLESS,1,0)
	attacker.addStatusCondition(recklessStatus)
	
	var discardedCard = await attacker.discardRandomCard()
	if discardedCard == null || !meetsRequirement(discardedCard, attacker, defender):
		BattleLog.singleton.log("Card does not meet requirements...")
		return 0

	attacker.addMP(2)

	
	return attackPower

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var attackPower = 0
	attackPower = 1.25*attacker.getAttack()
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	return attackPower
