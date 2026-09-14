extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Blackjack: Gain ATK+ 1. Deal (80% ATK) damage."
	name = "???"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.8

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
	
func onBlackjack(attacker: BattleMonster):
	await dealDamage(attacker, attacker.battleController.getActiveEnemyMon())
	pass
