extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "Deal (60% ATK) damage. If this card is played with a modified cost, gain Focus 2."
	name = "Expresso"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 0.6

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	if playedCost != cost:
		await giveStatus(attacker, Status.EFFECTS.FOCUS, 2)

func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster):
	if attacker.hasStatus(Status.EFFECTS.FOCUS) || attacker.hasStatus(Status.EFFECTS.FATIGUE):
		return Status.new(Status.EFFECTS.FOCUS, 2)
