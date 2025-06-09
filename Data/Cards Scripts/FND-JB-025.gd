extends Card

func _init() -> void:
	cost = 0
	priority = 2
	alignment = ALIGNMENT.Jacks
	role = "Basic"
	description = "If your opponent plays an Attack this action, nullify it. Otherwise, discard your hand. While this is in your hand, your Attacks deal (20% ATK) more damage and you discard this when you are hit."
	name = "The Bluff"
	tags = ['Utility']
	rarity = RARITY.Epic

func effect(attacker: BattleMonster, defender: BattleMonster):
	await giveStatus(attacker, Status.EFFECTS.BLUFF)

#checks what status will be given to the user
func calcStatusGiven(attacker: BattleMonster, defender: BattleMonster) -> Status:
	return Status.new(Status.EFFECTS.BLUFF)
