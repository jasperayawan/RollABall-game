extends Area3D


signal picked_up

func _ready():
	pass

func _on_body_entered(body):
	if body.is_in_group("Player"):
		picked_up.emit()
		queue_free()
