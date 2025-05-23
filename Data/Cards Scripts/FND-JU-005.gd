extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Hooliquen"
	description = "Reckless > 100% Attack. If Reckless, gain 2 mp."
	name = "Sinister Plotting"
	selfTarget = true

func meetsRequirement(card: Card, attacker: BattleMonster, defender: BattleMonster):
	if card.calcDamage(attacker,defender) > attacker.attack:
		return true
	else:
		return false

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	#calc attack power
	
	if !(await  applyReckless(attacker, defender)):
		BattleLog.singleton.log("Card does not meet requirements...")
		return 0

	var mpGain = 2
	
	if statusConditions.has(Status.EFFECTS.EMPOWER):
		mpGain = ceil(mpGain*1.5)
	#deal damage
	attacker.addMP(mpGain)
	return mpGain

func calcBonus(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 2
