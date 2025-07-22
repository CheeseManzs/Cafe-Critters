extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "The next time you swap out, create 1 Inspiration in the swapped in Fae's hand."
	name = "Dueting"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker, Status.EFFECTS.DUETING)
