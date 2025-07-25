extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Heal (5% Max HP) health. Draw 1."
	name = "Note of Triumph"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	var healed = attacker.maxHP*0.05
	await attacker.addHP(healed)
	await attacker.drawCards(1)
