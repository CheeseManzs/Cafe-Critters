extends Card

func _init() -> void:
	cost = 1
	priority = 0
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "This turn, when this fae Attacks, roll a die. If you rolled a 5 or 6, inflict Poison 5."
	name = "Poison Dipped"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	var num = await rollDice(attacker)
	
	if num >= 5:
		await giveStatus(defender, Status.EFFECTS.POISON, 5)

func calcStatusInflicted(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.POISON, 5)
