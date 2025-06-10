extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Draw 2. Take (5% Max HP) damage."
	name = "Burden of Knowledge"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Uncommon

func effect(attacker: BattleMonster, defender: BattleMonster):
	await attacker.drawCards(2)
	var dmg = attacker.maxHP*0.05
	await attacker.trueDamage(dmg,null,false,false)
