extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Blackjack: Gain (90% DEF) block. Deal (90% ATK) damage."
	name = "Placeholder Block"
	tags = ['Attack', 'Defence']
	rarity = RARITY.Uncommon
	power = 0.9
	shieldPower = 0.9

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	pass

func onBlackjack(attacker: BattleMonster):
	await giveShield(attacker, attacker.getActiveEnemy())
