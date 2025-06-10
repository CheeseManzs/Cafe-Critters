extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Omen. Your opponent faes take (10% Opponent Max Health) whenever they skip this turn."
	name = "Fight or Flight"
	tags = ['Utility', 'Omen']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(defender, Status.EFFECTS.FIGHT_OR_FLIGHT, 1)
	await applyOmen(attacker, defender)
