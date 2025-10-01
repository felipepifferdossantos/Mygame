class_name InventoryUI
extends Control

# A referência ao nó de inventário que esta UI deve exibir.
@export var inventory: Inventory

# O recurso da cena para um único slot da UI.
@export var inventory_slot_ui_scene: PackedScene

# O contêiner da grade onde os slots serão instanciados.
@onready var grid_container: GridContainer = $MarginContainer/GridContainer

func _ready():
	# Esconde a UI do inventário por padrão.
	hide()

	# Conecta ao inventário para ouvir por mudanças.
	if inventory:
		inventory.inventory_changed.connect(_on_inventory_changed)
		# Desenha o inventário pela primeira vez.
		_redraw_inventory()
	else:
		print_error("InventoryUI: Nó de inventário não foi definido.")

# Redesenha toda a grade do inventário.
func _redraw_inventory():
	# Limpa os slots antigos.
	for child in grid_container.get_children():
		child.queue_free()

	# Cria novos slots com base nos dados atuais do inventário.
	if inventory and inventory.slots:
		for slot_data in inventory.slots:
			var slot_ui_instance = inventory_slot_ui_scene.instantiate()
			grid_container.add_child(slot_ui_instance)
			slot_ui_instance.update(slot_data)

# Chamado quando o inventário emite o sinal 'inventory_changed'.
func _on_inventory_changed():
	_redraw_inventory()

# Alterna a visibilidade da UI do inventário.
func toggle():
	visible = not visible
	if visible:
		# Garante que a UI esteja atualizada quando for mostrada.
		_redraw_inventory()