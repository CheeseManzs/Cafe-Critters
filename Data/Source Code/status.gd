class_name Status

### DOCS: https://docs.google.com/document/d/1-AvuVqglh2m1z45S5vdLLJboG-nlISJO8bADr8wjpOU/edit?tab=t.9z20aqcbf1rl

#enum of status effects
enum EFFECTS {
	NONE,
	KO, #mon hp is 0
	DROWN,
	BURN,
	FOCUS,
	FATIGUE,
	ROOTED,
	BURNOUT
}
var X: int = 0
var effectDone = false
var effect: EFFECTS
var filter: CardFilter = CardFilter.new()

#ui connections
var icon: StatusIcon = null

# Flags
var carriesOnSwitch: bool 	= false
var endsOnSwitch: bool 		= false
var endsOnSubturn: bool		= false
var endsOnTurn: bool		= false
var isPositive: bool		= false
var isNumerable: bool		= true
var trapped: bool			= false
var nullifyDamage: bool		= false

# Helpers
func addX(x, user: BattleMonster = null):
	X += x
	effectDone = (X <= 0)
	
	if X <= 0 and user != null:
		onNonPositiveX(user)
		
func modifyCardDesc(card: Card) -> String:
	return card.description

func aiScore() -> float:
	return 0

# Data
var atkBoost: float:
	get:
		return p_atkBoost()

var defBoost: float:
	get:
		return p_defBoost()

var miniName: String:
	get:
		return p_nameMini()

var name: String:
	get:
		return p_nameFull()

var color: Color:
	get:
		return p_statusColor()

var damageReduction: int:
	get:
		return p_damageReduction()

# Events
func onNonPositiveX(user: BattleMonster):
	if isNumerable:
		user.removeStatus(effect)

## Triggers when a unit is afflicted with this status
func onApplied(user: BattleMonster):
	pass
	
## Triggers when a unit switches out
func onSwitchOut(user: BattleMonster):
	pass

## Triggers when a unit switches in
func onSwitchIn(user: BattleMonster):
	pass

## Triggers on the start of a sub turn
func onNewSubTurn(user: BattleMonster):
	pass

## Triggers at the end of a sub turn
func onSubTurnEnd(user: BattleMonster):
	pass

## Triggers on the start of a full turn
func onNewTurn(user: BattleMonster):
	pass

## Triggers at the end of a full turn
func onTurnEnd(user: BattleMonster):
	pass

## Triggers right before a card is played
func beforeCardPlayed(user: BattleMonster, card: Card):
	pass

## Triggers right after a card is played and fully resolves
func onCardPlayed(user: BattleMonster, card: Card):
	pass

## Triggers when a card is drawn into a Fae’s hand
func onCardDrawn(user: BattleMonster, card: Card):
	pass

## Triggers if any card is sent to the graveyard
func onCardSentToGraveyard(user: BattleMonster, card: Card):
	pass

## Triggers if a unit (so a Fae in this case) skips their turn
func onSkip(user: BattleMonster):
	pass

## Triggers if a unit its attacker for a non-zero amount of damage
func onAttacked(user: BattleMonster, attacker: BattleMonster):
	pass
	
## Triggers if a unit its attacked for a zero damage (fully blocked)
func onBlocked(user: BattleMonster, attacker: BattleMonster):
	pass

## Triggers if this status reduced incoming damage
func onReducedDamage(user: BattleMonster, reduction: int):
	pass



# Global Events
func global_onSwitchOut(user: BattleMonster):
	pass

func global_onSwitchIn(user: BattleMonster):
	pass

func global_onNewSubTurn(user: BattleMonster):
	pass

func global_onNewTurn(user: BattleMonster):
	pass

# Flag Events

func flag_onSwitchOut(user: BattleMonster):
	if endsOnSwitch:
		user.removeStatus(self.effect)

func flag_onSwitchIn(user: BattleMonster):
	pass

func flag_onNewSubTurn(user: BattleMonster):
	pass

func flag_onNewTurn(user: BattleMonster):
	pass

# Properties
func p_atkBoost() -> float:
	return 1

func p_defBoost() -> float:
	return 1

func p_nameMini() -> String:
	return "NUL"

func p_nameFull() -> String:
	return ""

func p_statusColor() -> Color:
	return Color.WHITE

func p_damageReduction() -> int:
	return 0

# Dynamic Flags
func p_skipsNextCard(user: BattleMonster, card: Card) -> bool:
	return false

func p_cannotPlay(user: BattleMonster, card: Card) -> bool:
	return false
