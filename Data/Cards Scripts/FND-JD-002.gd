extends Card

func _init() -> void:
	cost = 3
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Fold: Play me. Deal (75% ATK) damage."
	name = "Oops!"
	tags = ['Attack']
	rarity = RARITY.Common
	power = 0.75

func effect(attacker: BattleMonster, defender: BattleMonster):
	await dealDamage(attacker, defender)
	pass
	
func onDiscarded(attacker: BattleMonster):
	cost = 0
	var newSequence = BattleSequence.new([BattleAction.new(attacker, attacker.playerControlled, priority, -1, selfTarget, self, attacker.battleController)])
	await newSequence.runActions(attacker.battleController)
	cost = 3
