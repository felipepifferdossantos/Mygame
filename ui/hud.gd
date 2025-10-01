class_name HUD
extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var will_bar: TextureProgressBar = $WillBar
@onready var logic_bar: TextureProgressBar = $LogicBar

func update_health(current_health, max_health):
	update_bar(health_bar, current_health, max_health)

func update_will(current_will, max_will):
	update_bar(will_bar, current_will, max_will)

func update_logic(current_logic, max_logic):
	update_bar(logic_bar, current_logic, max_logic)

# Uma função genérica para atualizar qualquer barra de progresso com um tween.
func update_bar(bar: TextureProgressBar, current_value, max_value):
	bar.max_value = max_value

	var tween = create_tween()
	tween.tween_property(bar, "value", current_value, 0.2).set_trans(Tween.TRANS_SINE)