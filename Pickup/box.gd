extends Area3D


@export var collect_sound: AudioStreamPlayer3D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Play sound if set
		if collect_sound:
			collect_sound.play()
		print("Collected item!")
		queue_free()  # Remove the box
