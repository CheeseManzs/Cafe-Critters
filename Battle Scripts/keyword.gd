class_name Keyword
extends Node

static var keywords = [
	"Block",
	"Regen",
	"Focus",
	"Fatigue",
	"Poison",
	"Burn",
	"Fear",
	"Omen"
]

static var keywordDescriptions = {
	"Block": "Damage is dealt to block instead of your HP. End of turn: lose all block.",
	"Regen": "Start of turn: heal HP equal to X% of you max health, then decrease X by 1.",
	"Focus": "When you draw a card, decrease it's cost by 1. Then, decrease X by 1.",
	"Fatigue": "When you draw a card, increase it's cost by 1. Then, decrease X by 1.",
	"Poison": "When a card you own goes to the graveyard, take (X% Max HP) damage. Then, reduce X by 1.",
	"Burn": "On turn end take (X% Max HP) damage. Then, reduce X by 1.",
	"Fear": "When you're hit by an Attack, take (X% Max HP) damage. Then, reduce X by 1. If you fully block an Attack, lost all stacks of Fear.",
	"Omen": "When this card is in the graveyard, and another card with the same name is played, play this card, then shuffle it into it's owner's deck."
}

static func getDescription(keywordString) -> String:
	return keywordDescriptions[keywordString]
