class_name Keyword
extends Node

static var keywords = [
"Mill",
"Drown",
"Salvage",
"Block",
"Spin (rng keyword marker)",
"Blackjack",
"Switch",
"Reanimate",
"Scrap",
"Forge",
"Craft",
"Heat",
"Burn",
"Focus",
"Fatigue",
"Gold",
"Rooted",
"Recycle",
"Fold",
"ATK/DEF",
"Forged",
]

static var keywordDescriptions = {
"Mill": "Take the top X cards of your deck and put it into your graveyard",
"Drown": "If you have Drown greater than your current health by the end of your turn, you die. (Removes on switchout)",
"Salvage": "dunno if we want this to be a keyword",
"Block": "Number representing the next amount of dmg you can negate this round, goes down equal to dmg taken, lose all at end of round.",
"Spin (rng keyword marker)": "We'll do something with this too",
"Blackjack": "Additional effects if this is at the top of your deck when you play a card from hand. BJ effect will trigger AFTER the initial card has resolved. BJ cards enter GY after triggering.",
"Switch": "Turn I switch in effects",
"Reanimate": "Turns into a creature, does stuff for a bit and dies",
"Scrap": "Token (0 cost do nothing)",
"Forge": "Make the Forge stuff stronger",
"Craft": "Opens a menu and you get to choose cards from a list!",
"Heat": "I'm not typing this out, same as last time",
"Burn": "Does X dmg at the end of the round, then decrease this number by 1",
"Focus": "Reduce cost of next card drawn by 1, then decrease X by 1",
"Fatigue": "Increase cost of next card drawn by 1, then decrease X by 1",
"Gold": "Token (0 cost, gain 1 energy, draw 1)",
"Rooted": "Buffs for how long they've been in?",
"Recycle": "Put to the bottom of your deck",
"Fold": "Effect when Discarded",
"ATK+": "Increases Attack stat by 10% per stack",
"DEF+": "Increases Defense stat by 10% per stack",
"Forged": "Deals 5% ATK more damage and grants 5% DEF more block"
}

static func getDescription(keywordString) -> String:
	return keywordDescriptions[keywordString]
