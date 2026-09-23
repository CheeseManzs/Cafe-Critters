extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Blackjack: Deal (100% ATK) damage. "
	name = "Face Card"
	tags = ['Attack']
	rarity = RARITY.Uncommon
	power = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass

func onBlackjack(attacker: BattleMonster):
	await dealDamage(attacker, attacker.getActiveEnemy())
	await attacker.battleController.addToGraveyard(self, attacker)
