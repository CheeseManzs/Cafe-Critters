extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Gain (60% DEF) block. If this card is played with a modified cost, apply Fatigue 2 to opponent."
	name = "Latte"
	tags = ['Defence', ' Self-Target']
	rarity = RARITY.Uncommon
	shieldPower = 0.6

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	if playedCost != cost:
		await giveStatus(defender, Status.EFFECTS.FATIGUE, 2)

func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster):
	if attacker.hasStatus(Status.EFFECTS.FOCUS) || attacker.hasStatus(Status.EFFECTS.FATIGUE):
		return Status.new(Status.EFFECTS.FATIGUE, 2)
