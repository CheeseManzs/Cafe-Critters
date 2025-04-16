extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Ignetor"
	description = "50% Attack twice. Inflict 1 Burn."
	name = "Double Bite"
	power = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender, power/2)
	await dealDamage(attacker, defender, power/2)
	await giveStatus(defender,Status.EFFECTS.BURN,1)
	pass

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.BURN,1)
