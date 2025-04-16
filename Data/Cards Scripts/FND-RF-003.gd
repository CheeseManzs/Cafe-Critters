extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Forward"
	description = "Omen. Any Faes with 5% HP or less are executed."
	name = "Rea's Call"
	tags = ["Omen"]

func effect(attacker: BattleMonster, defender: BattleMonster):
	if defender.health <= defender.maxHP*0.05:
		BattleLog.log(defender.rawData.name + " cannot escape Rea!")
		await defender.trueDamage(defender.health,attacker)
	else:
		BattleLog.log("Nothing happens...")
	await applyOmen(attacker, defender)

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	if defender.health <= defender.maxHP*0.05:
		return 99999999 + omenCalc(attacker, defender)
	else:
		return 0 + omenCalc(attacker, defender)
