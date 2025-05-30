extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Apply Fatigue 1 to opponent. If they're Fatigued, apply Fatigue 3 instead."
	name = "Cripple"
	tags = ['Utility']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	if defender.hasStatus(Status.EFFECTS.FATIGUE):
		await giveStatus(attacker, Status.EFFECTS.FOCUS, 3)
	else:
		await giveStatus(attacker, Status.EFFECTS.FOCUS, 1)
