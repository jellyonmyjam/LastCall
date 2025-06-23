extends Node2D

@onready var drain: Area2D = $"../Workstation/Drain"
@onready var inventory_manager: Node2D = $"../InventoryManager"
var target_object: Area2D = null
var dragged_object: Area2D = null


func initiate_pour():
	var target_type = ""
	if target_object == drain:
		target_type = "Drain"
	else:
		target_type = target_object.item_type
	var dragged_type = dragged_object.item_type
	var target_id = target_object.get_meta("id")
	var dragged_id = dragged_object.get_meta("id")
	
	if target_type == "Drain" and dragged_type == "Jigger":
		inventory_manager.tool_inventory[dragged_id]["fill_level"] = 0.0
		inventory_manager.tool_inventory[dragged_id]["jigger_contents"] = ""
		
	if target_type == "Drain" and dragged_type == "Shaker":
		inventory_manager.tool_inventory[dragged_id]["fill_level"] = 0.0
		inventory_manager.tool_inventory[dragged_id]["contents"] = {}
		inventory_manager.tool_inventory[dragged_id]["has_ice"] = false
		
	if target_type == "Drain" and dragged_type == "Glass":
		inventory_manager.glass_inventory[dragged_id]["fill_level"] = 0.0
		inventory_manager.glass_inventory[dragged_id]["contents"] = {}
		inventory_manager.glass_inventory[dragged_id]["prep"] = "built"
		inventory_manager.glass_inventory[dragged_id]["has_ice"] = false
		inventory_manager.glass_inventory[dragged_id]["has_soda"] = false
	
	if target_type == "Shaker" and dragged_type == "Scooper":
		inventory_manager.tool_inventory[target_id]["has_ice"] = true
		
	if target_type == "Glass" and dragged_type == "Scooper":
		inventory_manager.glass_inventory[target_id]["has_ice"] = true
		
	if target_type == "Shaker" and dragged_type == "Jigger":
		var fill_level: float = inventory_manager.tool_inventory[dragged_id]["fill_level"]
		var ingredient: String = inventory_manager.tool_inventory[dragged_id]["jigger_contents"]
		var contents: Dictionary = inventory_manager.tool_inventory[target_id]["contents"]

		if ingredient != "":
			if contents.has(ingredient):
				contents[ingredient] += fill_level
			else:
				contents[ingredient] = fill_level

			inventory_manager.tool_inventory[target_id]["contents"] = contents
			inventory_manager.tool_inventory[dragged_id]["fill_level"] = 0.0
			inventory_manager.tool_inventory[dragged_id]["jigger_contents"] = ""
		print(contents)
			
	if target_type == "Glass" and dragged_type == "Jigger":
		print("test2")
		var fill_level: float = inventory_manager.tool_inventory[dragged_id]["fill_level"]
		var ingredient: String = inventory_manager.tool_inventory[dragged_id]["jigger_contents"]
		var contents: Dictionary = inventory_manager.glass_inventory[target_id]["contents"]

		if ingredient != "":
			if contents.has(ingredient):
				contents[ingredient] += fill_level
			else:
				print("test")
				contents[ingredient] = fill_level

			inventory_manager.glass_inventory[target_id]["contents"] = contents
			inventory_manager.tool_inventory[dragged_id]["fill_level"] = 0.0
			inventory_manager.tool_inventory[dragged_id]["jigger_contents"] = ""
		print(contents)
		
	if target_type == "Glass" and dragged_type == "Shaker":
		var contents: Dictionary = inventory_manager.tool_inventory[dragged_id]["contents"]
		var fill_level: float = inventory_manager.tool_inventory[dragged_id]["fill_level"]

		inventory_manager.glass_inventory[target_id]["contents"] = contents.duplicate()
		inventory_manager.glass_inventory[target_id]["fill_level"] = fill_level
		inventory_manager.glass_inventory[target_id]["prep"] = "shaken"

		inventory_manager.tool_inventory[dragged_id]["contents"] = {}
		inventory_manager.tool_inventory[dragged_id]["fill_level"] = 0.0
		print(contents)
		
