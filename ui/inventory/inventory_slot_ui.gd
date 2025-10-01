class_name InventorySlotUI
extends Panel

@onready var item_texture: TextureRect = $MarginContainer/ItemTexture
@onready var quantity_label: Label = $MarginContainer/QuantityLabel

# Atualiza a exibição do slot com base nos dados.
func update(slot_data):
	if slot_data and slot_data.item:
		item_texture.texture = slot_data.item.item_icon
		if slot_data.quantity > 1:
			quantity_label.text = "x" + str(slot_data.quantity)
			quantity_label.show()
		else:
			quantity_label.hide()
		item_texture.show()
	else:
		# Limpa o slot se não houver item.
		item_texture.texture = null
		item_texture.hide()
		quantity_label.hide()