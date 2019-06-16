extends Node

var cam
var main

var levels = []
var curr_level = 0

var p1_score = 0
var p2_score = 0

func _ready() -> void:
	levels = list_files_in_directory("res://Levels/")
	print(levels)
	
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append("Levels/" + file)

	dir.list_dir_end()

	return files
func get_curr_level():
	return levels[curr_level]
func get_next_level():
	curr_level += 1 if curr_level < levels.size() - 1 else 0
	return levels[curr_level]
	
func load_next_level():
	# Remove the current level
	var level = main.get_node("Level")
	main.remove_child(level)
	level.call_deferred("free")
	
	# Add the next level
	var next_level_resource = load(get_next_level())
	var next_level = next_level_resource.instance()
	main.add_child(next_level)
