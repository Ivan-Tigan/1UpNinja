extends Node2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var kin_head = $KinematicHead
onready var kin_body = $KinematicBody
onready var head : Sprite = $KinematicHead/Head
onready var body : Sprite = $KinematicBody/Body
onready var sound : AudioStream = load("res://Sounds/Gore.wav")
var head_velocity := Vector2(0, 0)
var timer = 0
var duration = 0.6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	head.visible = false
	body.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer < duration:
		head_velocity =  kin_head.move_and_slide(head_velocity)
		if head_velocity.length() > 0:
			timer += delta
			head.rotate(deg2rad(360 * 5 * delta))
#	pass
func explode():
	Globals.cam.shake()
	var audio = AudioStreamPlayer.new()
	audio.stream = sound
	add_child(audio)
	audio.play()
	head.visible = true
	body.visible = true
	head_velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * 300
	kin_body.rotate(deg2rad(-90))
	pass
