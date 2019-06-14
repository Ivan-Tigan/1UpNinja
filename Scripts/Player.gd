extends KinematicBody2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var player_index = 1
var velocity
export var speed = 300
var state = PlayerStates.Moving
onready var sprite = $Sprite



var h
var v

var slice_timer

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
	
	if state == PlayerStates.Slicing:
		slice_timer += delta
		velocity = Vector2(h, v).normalized() * speed * 6
		velocity = move_and_slide(velocity)
		if slice_timer >= 0.15:
			state = PlayerStates.Moving
	else:
		slice_timer = 0
		h = Input.get_action_strength("right" + str(player_index)) - Input.get_action_strength("left" + str(player_index))
		v = Input.get_action_strength("down" + str(player_index)) - Input.get_action_strength("up" + str(player_index))
	
	if state == PlayerStates.Moving:
		velocity = Vector2(h, v).normalized() * speed
		velocity = move_and_slide(velocity)
		
	if state == PlayerStates.Charging:
		$Aim.visible = true
		$Aim.look_at(position + Vector2(h, v).normalized())
	else:
		$Aim.visible = false
		
	
		
		
	sprite.flip_h = false if h > 0 else (true if h < 0 else sprite.flip_h)
	
	if Input.is_action_pressed("charge" + str(player_index)):
		state = PlayerStates.Charging
		
	if Input.is_action_just_released("charge" + str(player_index)):
		state = PlayerStates.Slicing
