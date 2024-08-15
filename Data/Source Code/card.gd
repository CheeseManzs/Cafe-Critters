#list of god alignments
enum ALIGNMENT {
	Mise,
	Scythanna,
	Anvi,
	Secs,
	Eco,
	Jacks
}

#list of roles
enum ROLE {
	Generic,
	Point,
	Payoff,
	Support,
	Unique,
	Token
}

#cost of card
var cost: int = 0
#priority of card
var priority: int = 0
#god alignment of card
var alignment: ALIGNMENT = ALIGNMENT.Mise
#role of card
var role: ROLE = ROLE.Generic
var description: String = ""
var name: String = ""
