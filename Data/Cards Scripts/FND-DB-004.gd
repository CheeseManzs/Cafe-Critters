extends Card

func _init() -> void:
	cost = 1
	priority = 1
	alignment = ALIGNMENT.Default
	role = ROLE.Generic
	description = "50% Defend."
	name = "Light Block"

	shieldPower = 0.5

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveShield(attacker, defender)
