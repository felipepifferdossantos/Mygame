class_name ItemPickup
extends Area2D

# O recurso do item que este pickup representa.
var item_resource: ItemResource

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	# Conecta o sinal de colisão a este próprio script.
	self.body_entered.connect(_on_body_entered)

	# Atualiza o sprite para corresponder ao ícone do item.
	if item_resource and item_resource.item_icon:
		sprite.texture = item_resource.item_icon
	else:
		# Se não houver ícone, usa uma cor de placeholder.
		sprite.modulate = Color.MAGENTA
		print_error("ItemPickup: item_resource ou seu ícone não foram definidos.")

# Chamado quando um corpo (como o jogador) entra na área.
func _on_body_entered(body):
	# Verifica se o corpo tem um nó filho chamado "Inventory".
	var inventory = body.get_node_or_null("Inventory")
	if inventory:
		# Tenta adicionar o item ao inventário.
		if inventory.add_item(item_resource):
			# Se o item foi adicionado com sucesso, remove o pickup do mundo.
			print("Coletado: " + item_resource.item_name)
			queue_free()
		else:
			# Se o inventário estiver cheio, o item permanece no chão.
			print("Não foi possível coletar: " + item_resource.item_name + ". Inventário cheio.")