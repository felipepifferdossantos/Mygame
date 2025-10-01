class_name ArmorItem
extends ItemResource

enum ArmorType { HELMET, CHESTPLATE, LEGGINGS, BOOTS }

@export var armor_type: ArmorType = ArmorType.CHESTPLATE
@export var defense: float = 5.0

func equip(target):
	# Logic to equip the armor on the target (player)
	if target.has_method("equip_armor"):
		target.equip_armor(self)
	print("Equipped " + item_name)

func unequip(target):
	# Logic to unequip the armor
	if target.has_method("unequip_armor"):
		target.unequip_armor(self)
	print("Unequipped " + item_name)