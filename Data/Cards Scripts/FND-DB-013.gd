extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "When you play this card, your faes can no longer play other cards for the rest of the turn. Deal (100% ATK) damage."
	name = "Last Stand"
	tags = ['Attack']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
