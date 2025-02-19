extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Guard"
	description = "30% Defense. if Regenerating, draw 2."
	name = "Recalibrate"
	shieldPower = 0.3
	selfTarget = true

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	if attacker.hasStatus(Status.EFFECTS.REGEN):
		await attacker.drawCards(2)
