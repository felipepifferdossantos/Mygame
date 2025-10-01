class_name Skill
extends Resource

enum ResourceType { WILL, LOGIC }

@export var skill_name: String = "New Skill"
@export_multiline var skill_description: String = "Skill description."
@export var skill_icon: Texture2D

@export var resource_type: ResourceType = ResourceType.WILL
@export var cost: int = 5

# Esta função será chamada pelo jogador para ativar o efeito da skill.
# O 'owner' é o nó que está usando a skill (o jogador).
func activate(owner):
	print("Activated skill: " + skill_name)
	# A lógica específica de cada skill será implementada em seus próprios scripts que herdam deste.
	pass