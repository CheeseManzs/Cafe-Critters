extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Inflict Fear 5. Deal (5% ATK) damage."
	name = "Freaky Shiv"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.05

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(defender, Status.EFFECTS.FEAR, 5)
	await dealDamage(attacker, defender)

func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.FEAR, 5)
