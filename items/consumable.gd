class_name ConsumableItem
extends ItemResource

enum Effect { HEAL, MANA_RECOVERY, BUFF }

@export var effect_type: Effect = Effect.HEAL
@export var effect_magnitude: float = 20.0

func use(target):
	# This function would be called when the player uses the item.
	# 'target' would typically be the player node.
	match effect_type:
		Effect.HEAL:
			if target.has_method("heal"):
				target.heal(effect_magnitude)
				print(target.name + " healed for " + str(effect_magnitude) + " HP.")
		Effect.MANA_RECOVERY:
			if target.has_method("recover_mana"):
				target.recover_mana(effect_magnitude)
				print(target.name + " recovered " + str(effect_magnitude) + " mana.")
		Effect.BUFF:
			# Buff logic would go here
			print("Applying buff...")

	print("Used " + item_name)