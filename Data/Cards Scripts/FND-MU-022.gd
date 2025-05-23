extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Mise
	role = "Inkhor"
	description = "50% Attack. The opponent Fae Mills 5. Salvage: 120% Attack."
	name = "Anchor Shot"
	power = 0.5

	
func effect(attacker: BattleMonster, defender: BattleMonster):
	if !salvaged:
		await dealDamage(attacker,defender)
		await defender.millCards(5)
	else:
		await dealDamage(attacker,defender, 1.2)
