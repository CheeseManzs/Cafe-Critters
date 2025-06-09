extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Deal (35% ATK) damage. If your opponent plays an Attack this action, nullify it."
	name = "Call"
	tags = ['Attack']
	rarity = RARITY.Rare
	power = 0.35

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	await giveStatus(attacker, Status.EFFECTS.CALL)
