extends Card

func _init() -> void:
	cost = 0
	priority = 1
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "Both players take turns rolling dice until a 1 is rolled, starting with the opponent. When a player rolls a 1, Execute their active fae."
	name = "Toby"
	tags = ['Utility']
	rarity = RARITY.Legendary

func effect(attacker: BattleMonster, defender: BattleMonster):
	while !attacker.isKO() && !defender.isKO():
		if !defender.isKO():
			var roll = await rollDice(defender)
			if roll == 1:
				await defender.getActiveTeammate().execute()
				break
		if !attacker.isKO():
			var roll = await rollDice(attacker)
			if roll == 1:
				await attacker.getActiveTeammate().execute()
				break
