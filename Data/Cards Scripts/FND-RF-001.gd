extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Forward"
	description = "Omen. Deal 1 direct damage."
	name = "Distant Screams"
	tags = ["Omen"]

func effect(attacker: BattleMonster, defender: BattleMonster):
	await defender.trueDamage(1, attacker)
	await applyOmen(attacker, defender)
	pass

func calcDamage(attacker: BattleMonster, defender: BattleMonster) -> int:
	return 1 + omenCalc(attacker, defender)
