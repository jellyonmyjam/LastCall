extends Node2D

@onready var snap_points_bottles: Node2D = $"../../Well/Sections/Bottles Section/Bottle Shelf/Snap Points Bottles"
@onready var bottle_objects: Node2D = $"../../Well/Sections/Bottles Section/Objects"
@onready var snap_points_glasses: Node2D = $"../../Well/Sections/Glassware Section/Glass Shelf/Snap Points Glasses"
@onready var glass_objects: Node2D = $"../../Well/Sections/Glassware Section/Objects"
@onready var snap_points_serve: Node2D = $"../../Dialogue/Snap Points Serve"
@onready var snap_points_tools: Node2D = $"../../Well/Sections/Items Section/Equipment Shelf/Snap Points Equipment"
@onready var tool_objects: Node2D = $"../../Well/Sections/Items Section/Objects"
@onready var snap_points_soda: Node2D = $"../../Well/Sections/Appliances Section/Soda Machine/Snap Points Soda"
@export var bottle_scene := preload("res://Scenes/base_bottle.tscn")
@export var glass_scene := preload("res://Scenes/base_glass.tscn")
@export var jigger_scene := preload("res://Scenes/jigger.tscn")
@export var shaker_scene := preload("res://Scenes/shaker.tscn")
@export var shaker_lid_scene := preload("res://Scenes/shaker_lid.tscn")
@onready var item_catalogue: Node2D = $"../ItemCatalogue"


var bottle_inventory = {
	1: {"name": "Spudmash", "fill_level": 25.0},
	2: {"name": "Knotroot Reserve", "fill_level": 25.0},
	3: {"name": "Mollassex Dark", "fill_level": 25.0},
	4: {"name": "Tang-O Deluxe", "fill_level": 10.0},
	5: {"name": "Pitfruit Synth", "fill_level": 25.0},
	6: {"name": "Aro-Agent Red", "fill_level": 25.0},
	7: {"name": "Vat Swill", "fill_level": 25.0},
	8: {"name": "Glucodex", "fill_level": 10.0}
}

var glass_inventory = {
	1: {"type": "Rocks", "fill_level": 0.0, "contents": {}, "prep": "Built", "has_ice": false, "has_soda": false},
	2: {"type": "Highball", "fill_level": 0.0, "contents": {}, "prep": "Built", "has_ice": false, "has_soda": false},
	3: {"type": "Mug", "fill_level": 0.0, "contents": {}, "prep": "Built", "has_ice": false, "has_soda": false},
	4: {"type": "Coupe", "fill_level": 0.0, "contents": {}, "prep": "Built", "has_ice": false, "has_soda": false}
}

var tool_inventory := {
	1: {"type": "Jigger", "fill_level": 0.0, "jigger_contents": "", "contents_name": "", "scene": jigger_scene},
	2: {"type": "Shaker", "fill_level": 0.0, "contents": {}, "shaken": false, "has_ice": false, "scene": shaker_scene},
	3: {"type": "Shaker Lid", "scene": shaker_lid_scene}
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
		var snap_offset = bottle_instance.snap_offset
		
		bottle_instance.name = bottle_name + " (" + str(id) + ")"
		bottle_instance.snap_points.append(snap_points_bottles)
		bottle_instance.set_meta("id", id)
		bottle_instance.set_meta("name", bottle_name)
		bottle_instance.texture_well = item_catalogue.bottle_data[bottle_name]["texture_well"]
		bottle_instance.texture_workstation = item_catalogue.bottle_data[bottle_name]["texture_workstation"]
	
		bottle_objects.add_child(bottle_instance)
		bottle_instance.global_position = point.global_position + snap_offset
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
		var snap_offset = glass_instance.snap_offset
		
		glass_instance.name = glass_name + " (" + str(id) + ")"
		glass_instance.snap_points.append(snap_points_glasses)
		glass_instance.snap_points.append(snap_points_serve)
		glass_instance.snap_points.append(snap_points_soda)
		glass_instance.set_meta("id", id)
		glass_instance.texture_well = item_catalogue.glass_data[glass_name]["texture_well"]
		glass_instance.texture_workstation = item_catalogue.glass_data[glass_name]["texture_workstation"]
		
		var liquid = glass_instance.get_node("Sprite2D").get_node("Liquid")
		var liquid_texture = item_catalogue.glass_data[glass_name]["texture_liquid"]
		var liquid_offset = item_catalogue.glass_data[glass_name]["liquid_offset"]
		liquid.texture = liquid_texture
		liquid.position = liquid_offset
	
		glass_objects.add_child(glass_instance)
		glass_instance.global_position = point.global_position + snap_offset
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
		var snap_offset = tool_instance.snap_offset
		
		tool_instance.name = tool_name + " (" + str(id) + ")"
		tool_instance.snap_points.append(snap_points_tools)
		tool_instance.set_meta("id", id)

		tool_objects.add_child(tool_instance)
		tool_instance.global_position = point.global_position + snap_offset
		tool_instance.current_snap_point = point
		point.set_meta("Occupied", true)

		index += 1
