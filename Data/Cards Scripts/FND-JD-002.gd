extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Deal (75% ATK) damage. \nFold: Play me."
	name = "Oops!"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.75

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	pass
	
func onDiscarded(attacker: BattleMonster):
	await dealDamage(attacker, attacker.getActiveEnemy())
	#cost = 0
	#var newSequence = BattleSequence.new([BattleAction.new(attacker, attacker.playerControlled, priority, -1, selfTarget, self, attacker.battleController)])
	#await newSequence.runActions(attacker.battleController)
	#cost = 3
