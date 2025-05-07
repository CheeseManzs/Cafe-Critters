extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Anvi
	role = "Forward"
	description = "As an additional cost to play this card, discard a token card from your hand. 125% Attack. If you have 50% HP or less, 175% Attack instead."
	name = "Scrappy Blow"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
	pass
