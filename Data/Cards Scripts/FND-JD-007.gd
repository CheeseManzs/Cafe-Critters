extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Deal (80% ATK) damage. \nBlackjack: Gain ATK+ 1."
	name = "Placeholder Erection"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.8

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	pass
	
func onBlackjack(attacker: BattleMonster):
	#attacker.battleController.EffectFlair.singleton._runFlair("Blackjack", Color.RED)
	await giveStatus(attacker, Status_Atk_Up.new(1))
	pass
