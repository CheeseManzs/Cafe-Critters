class_name Gift
extends Resource

enum GIFT_TYPE {
	MONSTER,
	DRINK,
	ITEM
}


@export var giftType: GIFT_TYPE
@export var code: String

func _init(_giftType, _code: String) -> void:
	if _giftType is String:
		giftType = GIFT_TYPE[_giftType]
	else:
		giftType = _giftType
	code = _code
	
