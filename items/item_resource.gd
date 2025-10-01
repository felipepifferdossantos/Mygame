class_name ItemResource
extends Resource

@export var item_name: String = "New Item"
@export_multiline var item_description: String = "Item description."
@export var item_icon: Texture2D
@export var stackable: bool = false
@export var max_stack_size: int = 1