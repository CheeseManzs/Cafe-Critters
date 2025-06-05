extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Gain (30% DEF) block. If Regenerating, draw 2."
	name = "Recalibrate"
	tags = ['Defence', 'Self-Target']
	rarity = RARITY.Uncommon
	shieldPower = 0.3

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	if attacker.hasStatus(Status.EFFECTS.REGEN):
		await attacker.drawCards(2)
		await attacker.battleController.get_tree().create_timer(1).timeout
