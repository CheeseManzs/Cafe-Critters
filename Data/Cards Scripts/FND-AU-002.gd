extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Ignetor"
	description = "20% Attack. Gain 2 Heat. Inflict 1 Burn."
	name = "Heat Pump"
	power = 0.2

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker,defender)
	await giveStatus(defender,Status.EFFECTS.BURN,1)
	await attacker.addHeat(2)
	pass

func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.BURN,1)
