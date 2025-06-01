extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Slocha"
	description = "For the rest of the turn, you do not lose Focus every time you draw a card."
	name = "Caffeinated Overdrive"
	tags = ['Utility']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker, Status.EFFECTS.CAFFEINATED_OVERDRIVE)
