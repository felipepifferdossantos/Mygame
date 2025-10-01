class_name LootTable
extends Resource

# Uma classe aninhada para definir um único item que pode ser dropado.
class LootDrop extends Resource:
	@export var item: ItemResource
	@export var weight: float = 1.0 # Maior o peso, maior a chance.

# O array de possíveis drops nesta tabela de loot.
@export var drops: Array[LootDrop]

# Calcula e retorna um único item com base nos pesos.
# Retorna null se a tabela de loot estiver vazia.
func get_loot() -> ItemResource:
	if drops.is_empty():
		return null

	var total_weight = 0.0
	for drop in drops:
		total_weight += drop.weight

	var random_value = randf() * total_weight

	for drop in drops:
		if random_value < drop.weight:
			return drop.item
		else:
			random_value -= drop.weight

	# Fallback, caso algo dê errado com os cálculos de float.
	return drops.back().item