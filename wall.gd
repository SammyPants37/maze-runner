extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(startPos):
	position = startPos
	
	# randomly deside whether or not to show lights
	if randf() > 0.6:
		$OmniLight3D.show()
		$OmniLight3D2.show()
		$OmniLight3D3.show()
		$OmniLight3D4.show()
