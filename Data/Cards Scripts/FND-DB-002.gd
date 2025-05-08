extends Card

func _init() -> void:
	cost = 2
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "100% Defend."
	name = "Block"
	selfTarget = true
	
	shieldPower = 1

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
