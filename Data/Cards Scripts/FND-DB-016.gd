extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Shuffle 3 Endless Blows into your deck. Deal (50% ATK) damage, plus (10% ATK) for each Endless Blows played this game"
	name = "Endless Blows"
	tags = ['Attack']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
