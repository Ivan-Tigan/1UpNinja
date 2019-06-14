extends KinematicBody2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _physics_process(delta):
	if Input.is_action_pressed("left"):
		velocity.x = -1
	if Input.is_action_pressed("right"):
		velocity.x = 1
	velocity = move_and_slide(velocity*200)
	