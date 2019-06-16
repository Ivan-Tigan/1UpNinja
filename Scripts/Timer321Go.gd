extends StaticBody2D

onready var anim := $AnimationPlayer
signal timeout

func start_countdown():
	anim.play("Countdown")

func go():
	emit_signal("timeout")