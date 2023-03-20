extends EnemyAttackState


func enter(_msg = {}):
	await get_tree().create_timer(attack_cooldown).timeout
	state_machine.transition_to("Hunt")
	
