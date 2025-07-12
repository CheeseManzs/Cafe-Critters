extends Card

func _init() -> void:
	cost = 4
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Draw 3. This turn, skills cost 1 less and your faes cannot draw."
	name = "Final Encore"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	pass
