extends Node2D


onready var soundtrack := $Soundtrack
onready var timer := $Timer321Go
onready var p1 = $Player
onready var p2 = $Player2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1.set_physics_process(false)
	p2.set_physics_process(false)
	timer.start_countdown()
	timer.connect("timeout", self, "start_soundtrack")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func start_soundtrack():
	p1.set_physics_process(true)
	p2.set_physics_process(true)
	soundtrack.play()
