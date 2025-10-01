class_name FuriousStrikeSkill
extends Skill

# Esta função substitui a função base 'activate'.
# Ela define o que o Golpe Furioso realmente faz.
func activate(owner):
	# Verifica se o 'owner' (o jogador) tem o método esperado para realizar o ataque.
	if owner.has_method("_perform_furious_strike"):
		# Chama o método no jogador.
		owner._perform_furious_strike()
		print("Player used Furious Strike!")
	else:
		print_error("FuriousStrikeSkill: O 'owner' não tem o método _perform_furious_strike().")

	# A dedução do custo (Vontade) será feita no script do jogador antes de chamar activate().