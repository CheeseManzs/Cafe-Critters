extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Shuffle 3 cards from any graveyard back into their respective fae's deck."
	name = "Reincarnate"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	for i in 3:
		if len(attacker.battleController.graveyard) > 0:
			var pickedID = attacker.battleController.global_rng.randi_range(0, len(attacker.battleController.graveyard) - 1)
			var card = attacker.battleController.graveyard[pickedID]
			
			if card.originator != null:
				attacker.battleController.removeFromGraveyardToOwnerDeck(card)
