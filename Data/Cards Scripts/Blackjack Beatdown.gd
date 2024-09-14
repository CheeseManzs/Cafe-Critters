extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = ROLE.Unique
	description = "Reckless > 100% Attack. If Reckless, Strongarm. Attack 200%."
	name = "Blackjack Beatdown"

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	if card.calcDamage(attacker,defender) > attacker.attack:
		return true
	else:
		return false

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	var attackPower = 0
	attackPower = 2*attacker.getAttack()
	
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	#deal damage
	defender.receiveDamage(attackPower, attacker)
	
	await EffectFlair.singleton._runFlair("Reckless")
	var discardedCard = await attacker.discardRandomCard()
	if discardedCard == null || !meetsRequirement(discardedCard, attacker, defender):
		BattleLog.singleton.log("Card does not meet requirements...")
		return 0

	await attacker.addStatusCondition(Status.new(Status.EFFECTS.STRONGARM),true)
	
	return attackPower

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	var attackPower = 0
	attackPower = 2*attacker.getAttack()
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		attackPower = ceil(attackPower*1.5)
	return attackPower

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.STRONGARM)
