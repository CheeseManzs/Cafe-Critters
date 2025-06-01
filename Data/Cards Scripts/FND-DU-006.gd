extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Double your Focus and double your opponent's Fatigue. Gain 1 MP."
	name = "Double Double"
	tags = ['Utility']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	if attacker.hasStatus(Status.EFFECTS.FOCUS):
		await giveStatus(attacker, Status.EFFECTS.FOCUS, attacker.getStatus(Status.EFFECTS.FOCUS).X)
	if defender.hasStatus(Status.EFFECTS.FATIGUE):
		await giveStatus(defender, Status.EFFECTS.FATIGUE, defender.getStatus(Status.EFFECTS.FATIGUE).X)
	await attacker.addMP(1)
