extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Default
	role = "Point"
	description = "Gain Haste 2."
	name = "Assist"

func effect(attacker: BattleMonster, defender: BattleMonster):
	var statusLevel
	await attacker.addStatusCondition(Status.new(Status.EFFECTS.HASTE, 2))
