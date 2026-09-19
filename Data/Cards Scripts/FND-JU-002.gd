extends Card

func _init() -> void:
	cost = 2
	priority = 0
	alignment = ALIGNMENT.Jacks
	description = "Blackjack: Play me. Deal (10% ATK) damage and draw 1."
	name = "Blunt End"
	tags = ['Attack']
	rarity = RARITY.Rare
	power = 0.1

func effect(attacker: BattleMonster, defender: BattleMonster):
	dealDamage(attacker, defender)
	attacker.drawCards(1)
	pass

func onBlackjack(attacker: BattleMonster):
	cost = 0
	var newSequence = BattleSequence.new([BattleAction.new(attacker, attacker.playerControlled, priority, -1, selfTarget, self, attacker.battleController)])
	await newSequence.runActions(attacker.battleController)
	cost = 2
