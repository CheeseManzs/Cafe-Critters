extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Rea
	role = "Basic"
	description = "Play only if you've been Attacked this turn. Omen. Deal (100% ATK) damage."
	name = "Vengeance"
	tags = ['Attack', 'Omen']
	rarity = RARITY.Common
	power = 1

func canBePlayed(user: BattleMonster):
	return user.wasAttackedThisTurn

func effect(attacker: BattleMonster, defender: BattleMonster):
	if attacker.wasAttackedThisTurn:
		await dealDamage(attacker, defender)
	else:
		BattleLog.log(attacker.getName() + " has not been attacked this turn!")
