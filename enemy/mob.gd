class_name Mob
extends CharacterBody2D

@export var health: int = 50
@export var damage: int = 10
@export var loot_table: LootTable
@export var item_pickup_scene: PackedScene = preload("res://objects/item_pickup.tscn")

var player_in_area = null
var attack_timer: Timer

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = 1.0 # Ataca a cada 1 segundo
	attack_timer.one_shot = false
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	add_child(attack_timer)

func take_damage(amount: int):
	health -= amount
	print("Mob took " + str(amount) + " damage. Health is now " + str(health))

	if health <= 0:
		_die()

func _die():
	print("Mob defeated!")

	if loot_table:
		var dropped_item = loot_table.get_loot()
		if dropped_item:
			var pickup_instance = item_pickup_scene.instantiate()
			pickup_instance.item_resource = dropped_item
			pickup_instance.global_position = self.global_position
			get_parent().add_child(pickup_instance)
			print("Dropped: " + dropped_item.item_name)

	queue_free()

func _on_hurtbox_body_entered(body):
	if body.is_in_group("player"): # Assumindo que o jogador estará no grupo "player"
		print("Player entered attack range.")
		player_in_area = body
		attack_timer.start()

func _on_hurtbox_body_exited(body):
	if body == player_in_area:
		print("Player exited attack range.")
		player_in_area = null
		attack_timer.stop()

func _on_attack_timer_timeout():
	if player_in_area and player_in_area.has_method("take_damage"):
		print("Mob attacks player.")
		player_in_area.take_damage(damage)