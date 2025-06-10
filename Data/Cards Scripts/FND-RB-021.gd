extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Deal (75% ATK) damage. Whenever this is placed into your graveyard, gain 1 MP and shuffle it back into your deck."
	name = "Earthbound Spirit"
	tags = ['Attack']
	rarity = RARITY.Rare

func onEnteredGraveyard(user: BattleMonster):
	await user.addMP(1)
	await user.battleController.removeFromGraveyardToOwnerDeck(self)

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
