extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "50% Attack. 50% Defend"
	name = "Shield Slap"
	power = 0.5
	shieldPower = 0.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
	await dealDamage(attacker, defender)
