extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Forward"
	description = "Omen. Any Faes with 5% HP or less are executed."
	name = "Rea's Call"

func effect(attacker: BattleMonster, defender: BattleMonster):
	if defender.health <= defender.maxHP*0.05:
		BattleLog.log("You cannot escape Rea!")
		await defender.trueDamage(defender.health,attacker)
	await applyOmen(attacker, defender)

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	if defender.health <= defender.maxHP*0.05:
		return 99999999 + omenCalc(attacker, defender)
	else:
		return 0 + omenCalc(attacker, defender)
