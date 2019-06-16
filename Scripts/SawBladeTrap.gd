extends KinematicBody2D

export var rotate_speed := 720



var body = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _physics_process(delta: float) -> void:
	$KinematicBody2D.rotate(deg2rad(rotate_speed * delta))
	

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("slice"):
		body.slice(true)
	pass # Replace with function body.
