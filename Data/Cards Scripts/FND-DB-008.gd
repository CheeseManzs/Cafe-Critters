extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "Take (300% Opponent ATK) damage. Draw 5 and gain 3 MP."
	name = "Last Chance"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Rare

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(defender, attacker, 3)
	await attacker.drawCards(5)
	await attacker.battleController.get_tree().create_timer(1.0).timeout
	await attacker.addMP(3)
