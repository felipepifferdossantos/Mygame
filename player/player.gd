extends CharacterBody2D

signal health_changed(current_health, max_health)
signal will_changed(current_will, max_will)
signal logic_changed(current_logic, max_logic)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var player_damage = 50

var max_health = 100
var health = 100:
	set(value):
		health = clamp(value, 0, max_health)
		emit_signal("health_changed", health, max_health)

var max_will = 10
var will = 0:
	set(value):
		will = clamp(value, 0, max_will)
		emit_signal("will_changed", will, max_will)

var max_logic = 10
var logic = 0:
	set(value):
		logic = clamp(value, 0, max_logic)
		emit_signal("logic_changed", logic, max_logic)

var is_invincible = false
var learned_skills = []

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var inventory: Inventory = $Inventory
@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	inventory.initialize(20)
	emit_signal("health_changed", health, max_health)
	emit_signal("will_changed", will, max_will)
	emit_signal("logic_changed", logic, max_logic)
	# Para teste, vamos "aprender" a skill no início.
	learn_skill(preload("res://skills/furious_strike.tres"))

func _physics_process(delta):
	# ... (código de movimento existente) ...
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# --- Input Handling ---
	if Input.is_action_just_pressed("attack"):
		_attack()
	if Input.is_action_just_pressed("toggle_inventory"):
		inventory_ui.toggle()
	if Input.is_action_just_pressed("skill_1"):
		use_skill(0) # Usa a primeira skill na lista

	move_and_slide()

func learn_skill(skill_resource: Skill):
	if not learned_skills.has(skill_resource):
		learned_skills.append(skill_resource)
		print("Learned skill: " + skill_resource.skill_name)

func use_skill(skill_index: int):
	if skill_index >= learned_skills.size():
		print("No skill at index " + str(skill_index))
		return

	var skill = learned_skills[skill_index]
	if skill.resource_type == Skill.ResourceType.WILL and self.will >= skill.cost:
		self.will -= skill.cost
		skill.activate(self)
	elif skill.resource_type == Skill.ResourceType.LOGIC and self.logic >= skill.cost:
		self.logic -= skill.cost
		skill.activate(self)
	else:
		print("Not enough resource to use " + skill.skill_name)

func _attack():
	$AttackHitbox/CollisionShape2D.disabled = false
	await get_tree().create_timer(0.2).timeout
	$AttackHitbox/CollisionShape2D.disabled = true

func _on_attack_hitbox_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(player_damage)
		_generate_will(1)

func _perform_furious_strike():
	$FuriousStrikeHitbox/CollisionShape2D.disabled = false
	await get_tree().create_timer(0.3).timeout
	$FuriousStrikeHitbox/CollisionShape2D.disabled = true

func _on_furious_strike_hitbox_body_entered(body):
	if body.has_method("take_damage"):
		var furious_damage = int(player_damage * 1.5) # Golpe Furioso causa 50% a mais de dano
		body.take_damage(furious_damage)
		print("Furious Strike hit for " + str(furious_damage) + " damage!")
		_generate_will(2) # A skill gera mais Vontade

func _generate_will(amount: int):
	self.will += amount
	print("Gained " + str(amount) + " Will. Current Will: " + str(self.will))

func take_damage(amount):
	if is_invincible: return
	self.health -= amount
	if health <= 0: get_tree().reload_current_scene()
	else: _start_invincibility()

func _start_invincibility():
	is_invincible = true
	var tween = create_tween().set_loops(5)
	tween.tween_property(sprite, "modulate:a", 0.5, 0.1)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1)
	await tween.finished
	is_invincible = false

func heal(amount): self.health += amount
func recover_mana(amount): print("Recovered " + str(amount) + " mana.")
func equip_weapon(item): player_damage = item.damage
func unequip_weapon(item): player_damage = 10
func equip_armor(item): print("Equipped " + item.item_name)
func unequip_armor(item): print("Unequipped " + item.item_name)