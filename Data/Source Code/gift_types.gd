@tool
class_name Gift
extends Resource

enum GIFT_TYPE {
	MONSTER,
	DRINK,
	ITEM
}


@export var giftType: GIFT_TYPE:
	set(value):
		giftType = value
		notify_property_list_changed()
@export var monsterCode: String

func _validate_property(property: Dictionary) -> void:
	if property.name == "monsterCode" && giftType != GIFT_TYPE.MONSTER:
		property.usage != PROPERTY_USAGE_READ_ONLY
