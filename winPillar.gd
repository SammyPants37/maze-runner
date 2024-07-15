extends StaticBody3D

signal win

# let the main script know that the win pillar has been entered
func _on_area_3d_area_entered(area):
	win.emit()
