extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Blackjack: Play me. Play the top card of your deck as if you played it from your hand."
	name = "Ace in the Hole"
	tags = ['Utility']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
