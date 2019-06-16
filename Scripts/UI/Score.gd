extends Control

export var player_index = 1
export var star_texture : Texture = preload("res://Textures/star_blue.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var score = Globals.p1_score if player_index == 1 else Globals.p2_score
	var gold_stars = score / 5
	var normal_stars = score % 5
	for i in gold_stars:
		var star = TextureRect.new()
		star.texture = preload("res://Textures/GoldStarAnimatedTexture.tres")
		$HBoxContainer.add_child(star)
	for i in normal_stars:
		var star = TextureRect.new()
		star.texture = star_texture
		$HBoxContainer.add_child(star)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
