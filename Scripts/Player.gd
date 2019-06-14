extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
<<<<<<< HEAD
var velocity : Vector2
=======
export var player_index = 1
var velocity
export var speed = 300
var state = PlayerStates.Moving

onready var sprite = $Sprite
onready var damage_area = $Aim/Arrow/DamageArea
onready var anim = $AnimationPlayer


var h
var v

var charge_speed = 8

var slice_timer
var charge_timer = 0
var min_charge = 0.3
var max_charge = 3


enum PlayerStates {
	Idle,
	Moving,
	Charging,
	Slicing,
	Dead
}
>>>>>>> 2b35988fe8289ec3ab88964b7e8166ea69d8a26c

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
<<<<<<< HEAD
func _physics_process(delta):
	if Input.is_action_pressed("left"):
		velocity.x = -1
	if Input.is_action_pressed("right"):
		velocity.x = 1
	velocity = move_and_slide(velocity*200)
	
=======

func _physics_process(delta: float) -> void:
	if state == PlayerStates.Dead:
		print("Dead")
		return

	if state == PlayerStates.Slicing:
		anim.play("Slice")
		damage_area.monitoring = true
		slice_timer += delta
		velocity = Vector2(h, v).normalized() * speed * charge_speed
		velocity = move_and_slide(velocity)
		print(slice_timer)
		if slice_timer >= (clamp(charge_timer, min_charge, max_charge) / max_charge) * 0.2:
			state = PlayerStates.Moving
			charge_timer = 0
	else:
		damage_area.monitoring = false
		slice_timer = 0
		h = Input.get_action_strength("right" + str(player_index)) - Input.get_action_strength("left" + str(player_index))
		v = Input.get_action_strength("down" + str(player_index)) - Input.get_action_strength("up" + str(player_index))
		
		
		
	if state == PlayerStates.Idle:
		anim.play("Idle")
		pass
		
	if state == PlayerStates.Moving:
		anim.play("Walk")
		velocity = Vector2(h, v).normalized() * speed
		velocity = move_and_slide(velocity)
		
	if state == PlayerStates.Charging:
		anim.play("Charge")
		charge_timer += delta
		$Aim.visible = true
		$Aim.look_at(position + Vector2(h, v).normalized())
	else:
		$Aim.visible = false
		
		
	sprite.flip_h = false if h > 0 else (true if h < 0 else sprite.flip_h)
	
	
	
	if not state == PlayerStates.Charging and not state == PlayerStates.Slicing:
		if h == 0 and v == 0:
			state = PlayerStates.Idle
		else:
			state = PlayerStates.Moving
	
	if Input.is_action_pressed("charge" + str(player_index)):
		state = PlayerStates.Charging
			
	if Input.is_action_just_released("charge" + str(player_index)):
		state = PlayerStates.Slicing
<<<<<<< HEAD
>>>>>>> 2b35988fe8289ec3ab88964b7e8166ea69d8a26c
=======
	
	


func _on_DamageArea_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("slice"):
		body.slice()
	pass # Replace with function body.
	
func slice():
	state = PlayerStates.Dead
>>>>>>> bd17012c6f9cbcca69dd571ee4174abcc413ecaa
