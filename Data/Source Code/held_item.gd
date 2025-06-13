class_name HeldItem
extends Resource

enum TIER {
	Mild,
	Balanced,
	Strong,
	Intense
}

enum SCALETYPE {
	Flat,
	Percent,
	ScalingFlat
}

var alignment: Monster.ALIGNMENT
var bonusAlignment: Monster.ALIGNMENT

var baseStats = [0, 0, 0, 0]

var passive: PassiveAbility
