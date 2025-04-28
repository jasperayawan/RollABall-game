extends Node3D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.x -= event.relative.y * 0.005
		rotation.y -= event.relative.x * 0.005
	
