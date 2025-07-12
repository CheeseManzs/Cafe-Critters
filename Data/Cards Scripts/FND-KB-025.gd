extends Card

func _init() -> void:
	cost = 1
	priority = 2
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Nullify the next skill the opponent plays this action. If you played 3- skills last turn, take (100% ATK) damage."
	name = "Destructive Interference"
	tags = ['Utility']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
