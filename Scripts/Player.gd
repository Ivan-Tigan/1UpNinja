extends KinematicBody2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var player_index = 1
var velocity
export var speed = 300
var state = PlayerStates.Moving
enum PlayerStates {
	Moving,
	Charging,
	Slicing,
	Dead
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _physics_process(delta: float) -> void:
	if state == PlayerStates.Moving:
		var h = Input.get_action_strength("right" + str(player_index)) - Input.get_action_strength("left" + str(player_index))
		var v = Input.get_action_strength("down" + str(player_index)) - Input.get_action_strength("up" + str(player_index))
		velocity = Vector2(h, v).normalized() * speed
		velocity = move_and_slide(velocity)
