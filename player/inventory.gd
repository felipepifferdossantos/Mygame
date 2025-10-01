class_name Inventory
extends Node

# Uma classe aninhada para representar um único espaço no inventário.
class InventorySlot extends Resource:
	@export var item: ItemResource
	@export var quantity: int

# O array de espaços que compõem o inventário.
@export var slots: Array[InventorySlot]

# Um sinal para notificar a UI quando o inventário mudar.
signal inventory_changed

# Inicializa o inventário com um número fixo de espaços vazios.
func initialize(size: int = 20):
	if slots.is_empty():
		for i in range(size):
			slots.append(InventorySlot.new())
	emit_signal("inventory_changed")

# Tenta adicionar um item ao inventário.
# Retorna true se o item foi adicionado com sucesso.
func add_item(p_item: ItemResource, p_quantity: int = 1) -> bool:
	# Primeiro, tenta empilhar com itens existentes, se possível.
	if p_item.stackable:
		for slot in slots:
			if slot.item != null and slot.item.item_name == p_item.item_name:
				if slot.quantity + p_quantity <= slot.item.max_stack_size:
					slot.quantity += p_quantity
					emit_signal("inventory_changed")
					return true

	# Se não for empilhável ou nenhuma pilha existente foi encontrada/estava cheia, encontra um espaço vazio.
	for slot in slots:
		if slot.item == null:
			slot.item = p_item
			slot.quantity = p_quantity
			emit_signal("inventory_changed")
			return true

	# Inventário está cheio.
	print("Inventário cheio. Não foi possível adicionar " + p_item.item_name)
	return false

# Tenta remover um item do inventário.
func remove_item(p_item_name: String, p_quantity: int = 1):
	for slot in slots:
		if slot.item != null and slot.item.item_name == p_item_name:
			slot.quantity -= p_quantity
			if slot.quantity <= 0:
				# Se a pilha estiver vazia, limpa o espaço.
				slot.item = null
				slot.quantity = 0
			emit_signal("inventory_changed")
			return