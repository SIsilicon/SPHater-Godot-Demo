extends Panel

var Constants = preload('Constants.gd')

var current_draw_mode = Constants.DRAW_MODE_BLOB

func swap(draw_mode=Constants.DRAW_MODE_BLOB):
	if draw_mode == current_draw_mode: return
	
	if current_draw_mode != Constants.DRAW_MODE_BLOB:
		$Tween.interpolate_property(self, 'rect_position', Vector2(), Vector2(-120,0), 0.5,\
			Tween.TRANS_QUAD, Tween.EASE_IN)
	if draw_mode != Constants.DRAW_MODE_BLOB:
		var delay = 0.5 if current_draw_mode != Constants.DRAW_MODE_BLOB else 0
		
		$Tween.interpolate_callback(self, delay, 'switch_visual', draw_mode)
		$Tween.interpolate_property(self, 'rect_position', Vector2(-120,0), Vector2(), 0.5,\
			Tween.TRANS_QUAD, Tween.EASE_OUT, delay)
	$Tween.start()
	
	current_draw_mode = draw_mode

func switch_visual(vis):
	match vis:
		Constants.DRAW_MODE_PRESSURE:
			$Bar.texture = preload('vis_pressure.tres')
			$BarType.text = 'Pressure'
			$MinVal.text = '0'
			$MaxVal.text = '100'
		Constants.DRAW_MODE_VISCOSITY:
			$Bar.texture = preload('vis_viscosity.tres')
			$MinVal.text = '0'
			$MaxVal.text = '500'
			$BarType.text = 'Viscosity'