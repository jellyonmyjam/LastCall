extends Node2D

@onready var snap_points_bottles: Node2D = $"../Well/Sections/Bottles Section/Bottle Shelf/Snap Points Bottles"
@export var bottle_scene := preload("res://Scenes/base_bottle.tscn")
@onready var bottle_objects: Node2D = $"../Well/Sections/Bottles Section/Objects"
@onready var snap_points_glasses: Node2D = $"../Well/Sections/Glassware Section/Glass Shelf/Snap Points Glasses"
@export var glass_scene := preload("res://Scenes/base_glass.tscn")
@onready var glass_objects: Node2D = $"../Well/Sections/Glassware Section/Objects"
@onready var snap_points_serve: Node2D = $"../Dialogue/Snap Points Serve"
@export var jigger_scene := preload("res://Scenes/jigger.tscn")
@export var shaker_scene := preload("res://Scenes/shaker.tscn")
@onready var snap_points_tools: Node2D = $"../Well/Sections/Items Section/Equipment Shelf/Snap Points Equipment"
@onready var tool_objects: Node2D = $"../Well/Sections/Items Section/Objects"


var bottle_inventory = {
	1: {"name": "Grey Goose", "fill_level": 25.0},
	2: {"name": "Captain Morgan", "fill_level": 25.0},
	3: {"name": "Jack Daniel's", "fill_level": 25.0}
}

var glass_inventory = {
	1: {"type": "Rocks", "fill_level": 0.0, "contents": {}, "has_ice": false},
	2: {"type": "Highball", "fill_level": 0.0, "contents": {}, "has_ice": false},
	3: {"type": "Mug", "fill_level": 0.0, "contents": {}, "has_ice": false}
}

var tool_inventory := {
	1: {"type": "Jigger", "fill_level": 0.0, "jigger_contents": "", "scene": jigger_scene},
	2: {"type": "Shaker", "fill_level": 0.0, "contents": {}, "has_ice": false, "scene": shaker_scene},
}

func _ready():
	bottle_spawn()
	glass_spawn()
	tool_spawn()

func bottle_spawn():
	var index = 0
	var bottle_ids = bottle_inventory.keys()
	
	for point in snap_points_bottles.get_children():
		if index >= bottle_inventory.size():
			break
			
		var id = bottle_ids[index]
		var bottle_data = bottle_inventory[id]
	
		var bottle_name = bottle_data["name"]
		var bottle_instance = bottle_scene.instantiate()
		bottle_instance.name = bottle_name + " (" + str(id) + ")"
		bottle_instance.snap_points.append(snap_points_bottles)
		bottle_instance.set_meta("id", id)
		bottle_instance.set_meta("name", bottle_name)
	
		bottle_objects.add_child(bottle_instance)
		bottle_instance.global_position = point.global_position
		bottle_instance.current_snap_point = point
		point.set_meta("Occupied", true)

		index += 1
		
func glass_spawn():
	var index = 0
	var glass_ids = glass_inventory.keys()
	
	for point in snap_points_glasses.get_children():
		if index >= glass_inventory.size():
			break
	
		var id = glass_ids[index]
		var glass_data = glass_inventory[id]
	
		var glass_name = glass_data["type"]
		var glass_instance = glass_scene.instantiate()
		glass_instance.name = glass_name + " (" + str(id) + ")"
		glass_instance.snap_points.append(snap_points_glasses)
		glass_instance.snap_points.append(snap_points_serve)
		glass_instance.set_meta("id", id)
	
		glass_objects.add_child(glass_instance)
		glass_instance.global_position = point.global_position
		glass_instance.current_snap_point = point
		point.set_meta("Occupied", true)

		index += 1
		
func tool_spawn():
	var index = 0
	var tool_ids = tool_inventory.keys()

	for point in snap_points_tools.get_children():
		if index >= tool_ids.size():
			break

		var id = tool_ids[index]
		var tool_data = tool_inventory[id]

		var tool_name = tool_data["type"]
		var tool_instance = tool_data["scene"].instantiate()
		tool_instance.name = tool_name + " (" + str(id) + ")"
		tool_instance.snap_points.append(snap_points_tools)
		tool_instance.set_meta("id", id)

		tool_objects.add_child(tool_instance)
		tool_instance.global_position = point.global_position
		tool_instance.current_snap_point = point
		point.set_meta("Occupied", true)

		index += 1
