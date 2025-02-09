extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Anvi
    role = "Basic"
	description = "As an additional cost to play this card, discard a card from your hand. Create Scrap equal to that card's mana cost."
	name = "Scrap"

func effect(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass

func calcShield(attacker: BattleMonster, defender: BattleMonster) -> int:
    pass
