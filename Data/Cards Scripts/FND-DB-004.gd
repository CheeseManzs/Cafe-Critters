extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Default
	role = "Basic"
	description = "50% Defend."
	name = "Light Block"
	selfTarget = true

	shieldPower = 0.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
