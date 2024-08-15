class_name Card

#list of god alignments
enum ALIGNMENT {
	Default,
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
var cost: int
#priority of card
var priority: int
#god alignment of card
var alignment: ALIGNMENT
#role of card
var role: ROLE
#card desc
var description: String
#card name
var name: String

func effect() -> void:
	pass
