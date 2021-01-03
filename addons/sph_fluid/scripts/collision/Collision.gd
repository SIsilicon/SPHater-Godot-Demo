extends Node2D

func calculate(draw_point, particle, space_state):
	var intersections = space_state.intersect_point(
			#particle_draw_position,
			draw_point.position, 
			32, 
			[], 
			0x7FFFFFFF, 
			true, 
			true)
			
	if intersections.empty():
		return
	
	# se a parede está a direita
	if particle.velocity.x > 0:
				#SPH.particles[p].position.x -= 1
		particle.velocity.x *= -0.1

	# se a parede está a esquerda
	if particle.velocity.x < 0:
		particle.velocity.x *= -0.1

	# se a parede está acima
	if particle.velocity.y > 0:
		particle.velocity.y *= -0.1
				
	# se a parede está abaixo
	if particle.velocity.y > 0:
		particle.velocity.y *= -0.1
