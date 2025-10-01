class_name CurrencyItem
extends ItemResource

# This type of item is mostly for data.
# The value is inherent in its name/type.
# It's always stackable.

func _init():
	stackable = true
	max_stack_size = 9999 # A large number for currency