extends StaticBody3D

func initialize(startPos):
	position = startPos
	
	# randomly deside whether or not to hide lights
	if randf() < 0.2:
		# hide the light and lantern model
		$lamp1.hide()
		$lamp2.hide()
		$lamp3.hide()
		$lamp4.hide()
		# disable the hitbox
		$lamp1.disabled = true
		$lamp2.disabled = true
		$lamp3.disabled = true
		$lamp4.disabled = true
