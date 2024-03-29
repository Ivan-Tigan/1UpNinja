extends KinematicBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export var player_index = 1
export(AtlasTexture) var atlas 
var velocity
export var speed = 250
var state = PlayerStates.Moving

export var curve_charge_up : Curve

onready var sprite = $Sprite
onready var dead_body = $DeadBody
onready var damage_area = $Aim/Arrow/DamageArea
onready var anim = $AnimationPlayer
onready var after_image = $AfterImage
onready var anim_shadow := $Shadow/ShadowAnimationPlayer

onready var yell_audio := $SliceYell
onready var swoosh_audio := $Swoosh

onready var charge_particles := $Charge_Particles

var h
var v

var dash_cooldown_timer = 2.5
var dash_cooldown = 2.5
var dash_vector := Vector2(0,0)
var h_dash
var v_dash
var dash_duration = 0.1
var dash_timer = 0
var dash_speed = 8

var charge_speed = 6
var slice_timer
var charge_timer = 0
var min_charge_threshold = 0.125
var min_charge = 0
var max_charge = 1.5


enum PlayerStates {
	Idle,
	Moving,
	Charging,
	Slicing,
	Dashing,
	Dead
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = atlas
	dead_body.set_atlas(atlas)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _physics_process(delta: float) -> void:

	if state == PlayerStates.Dead:
		print("Dead")
		return
	
	if state == PlayerStates.Dashing:
		anim.play("Dash")
		dash_timer += delta
		charge_timer = 0
		if dash_timer <= dash_duration:
			velocity = dash_vector * speed * dash_speed
			velocity = move_and_slide(velocity)
			if not swoosh_audio.playing:
				swoosh_audio.pitch_scale = rand_range(1, 1.3)
				swoosh_audio.play()
		else:
			state = PlayerStates.Moving
			dash_timer = 0
			dash_cooldown_timer = 0
			
	else:
		dash_cooldown_timer += delta
		h_dash = Input.get_action_strength("right_dash" + str(player_index)) - Input.get_action_strength("left_dash" + str(player_index))
		v_dash = Input.get_action_strength("down_dash" + str(player_index)) - Input.get_action_strength("up_dash" + str(player_index))
		
	
	if state == PlayerStates.Slicing:
		anim.play("Slice")
		damage_area.monitoring = true
		slice_timer += delta
		
		if slice_timer >= (clamp(charge_timer - min_charge_threshold, min_charge, max_charge) / max_charge) * 0.4:
			state = PlayerStates.Moving
			charge_timer = 0
			
		else:
			velocity = Vector2(h, v).normalized() * speed * charge_speed
			velocity = move_and_slide(velocity)
			if velocity.length() > 200:
				if not yell_audio.playing:
					yell_audio.pitch_scale = rand_range(1, 1.3)
					yell_audio.play()
					swoosh_audio.pitch_scale = rand_range(1, 1.3)
					swoosh_audio.play()
		#print(velocity.length())
		
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
		charge_particles.speed_scale = (2 + curve_charge_up.interpolate(charge_timer/max_charge) * 10)
		anim.play("Charge" if charge_timer < max_charge else "MaxCharge")
		charge_timer += delta
		$Aim.visible = true
		$Aim.look_at(position + Vector2(h, v).normalized())
	else:
		$Aim.visible = false
		
		
	sprite.flip_h = false if h > 0 else (true if h < 0 else sprite.flip_h)
	dead_body.head.flip_h = sprite.flip_h
	dead_body.body.flip_h = sprite.flip_h
	
	
	if not state == PlayerStates.Charging and not state == PlayerStates.Slicing:
		if h == 0 and v == 0:
			state = PlayerStates.Idle
		else:
			state = PlayerStates.Moving
	
	
	
	if not state == PlayerStates.Dashing and not state == PlayerStates.Slicing and Input.is_action_pressed("charge" + str(player_index)):
		state = PlayerStates.Charging
			
	if not state == PlayerStates.Dashing and state == PlayerStates.Charging and Input.is_action_just_released("charge" + str(player_index)):
		state = PlayerStates.Slicing
	
	dash_vector = Vector2(h_dash, v_dash).normalized()
	if dash_cooldown_timer >= dash_cooldown and not state == PlayerStates.Slicing and dash_vector.length() > 0.1:
		dash_vector = dash_vector.normalized()
		state = PlayerStates.Dashing
	
	after_image.emitting = true if state == PlayerStates.Dashing or state == PlayerStates.Slicing else false
	charge_particles.emitting = state == PlayerStates.Charging
	anim_shadow.play("Bounce" if not state == PlayerStates.Charging else "BounceCharging")

func _on_DamageArea_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method("slice"):
		body.slice()
	pass # Replace with function body.
	
func slice(force_death = false):
	if not force_death and state == PlayerStates.Dashing:
		return
	if player_index == 1:
		Globals.p2_score += 1
	else:
		Globals.p1_score += 1
	dead_body.explode()
	call_deferred("remove_child", dead_body)
	get_parent().call_deferred("add_child", dead_body)
	dead_body.position = position
	state = PlayerStates.Dead
	var timer = Timer.new()
	timer.wait_time = 2
	timer.connect("timeout", Globals, "load_next_level")
	get_parent().add_child(timer)
	timer.start()
	queue_free()

