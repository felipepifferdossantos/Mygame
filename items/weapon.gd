class_name WeaponItem
extends ItemResource

enum WeaponType { SWORD, AXE, DAGGER, BOW }

@export var weapon_type: WeaponType = WeaponType.SWORD
@export var damage: float = 10.0
@export var attack_speed: float = 1.0

func equip(target):
	# Logic to equip the weapon on the target (player)
	# This would typically modify the player's stats.
	if target.has_method("equip_weapon"):
		target.equip_weapon(self)
	print("Equipped " + item_name)

func unequip(target):
	# Logic to unequip the weapon
	if target.has_method("unequip_weapon"):
		target.unequip_weapon(self)
	print("Unequipped " + item_name)