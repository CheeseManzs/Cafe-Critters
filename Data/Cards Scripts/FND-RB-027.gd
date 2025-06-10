extends Card

func _init() -> void:
	cost = 3
	priority = 1
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Gain (100% DEF) block. Each turn start: if this is in the graveyard, gain (10% DEF) block."
	name = "Eternal Guardians"
	tags = ['Defence']
	rarity = RARITY.Epic
	shieldPower = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	await giveStatus(attacker, Status.EFFECTS.ETERNAL_GUARDIANS)
	pass
