extends Card

func _init() -> void:
	cost = 0
	priority = 0
	alignment = ALIGNMENT.Kress
	role = "Basic"
	description = "Does nothing."
	name = "Inspiration"
	tags = ['Utility', 'Self-Target']
	rarity = RARITY.Common

func effect(attacker: BattleMonster, defender: BattleMonster):
	await BattleLog.singleton.log("Nothing Happened...")
	pass
