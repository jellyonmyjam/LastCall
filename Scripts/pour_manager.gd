extends Node2D

@onready var drain: Area2D = $"../../Workstation/Drain"
@onready var inventory_manager: Node2D = $"../InventoryManager"
@onready var item_catalogue: Node2D = $"../ItemCatalogue"


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
		inventory_manager.glass_inventory[dragged_id]["prep"] = "Built"
		inventory_manager.glass_inventory[dragged_id]["has_ice"] = false
		inventory_manager.glass_inventory[dragged_id]["has_soda"] = false
		
		var liquid = dragged_object.get_node("Sprite2D").get_node("Liquid")
		var liquid_top = dragged_object.get_node("Sprite2D").get_node("Liquid Top")
		var shader_mat = liquid.material as ShaderMaterial
		shader_mat.set_shader_parameter("fill_amount", 0.0)
		liquid_top.current_fill = 0.0
	
	
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
		var fill_level: float = inventory_manager.tool_inventory[dragged_id]["fill_level"]
		var ingredient: String = inventory_manager.tool_inventory[dragged_id]["jigger_contents"]
		var ingredient_name: String = inventory_manager.tool_inventory[dragged_id]["contents_name"]
		var contents: Dictionary = inventory_manager.glass_inventory[target_id]["contents"]
		var ingredient_color = item_catalogue.bottle_data[ingredient_name]["color"]
		print(ingredient_color)

		if ingredient != "":
			if contents.has(ingredient):
				contents[ingredient] += fill_level
			else:
				contents[ingredient] = fill_level

			inventory_manager.glass_inventory[target_id]["contents"] = contents
			inventory_manager.glass_inventory[target_id]["fill_level"] += fill_level
			inventory_manager.tool_inventory[dragged_id]["fill_level"] = 0.0
			inventory_manager.tool_inventory[dragged_id]["jigger_contents"] = ""
			
			var liquid = target_object.get_node("Sprite2D").get_node("Liquid")
			var liquid_top = target_object.get_node("Sprite2D").get_node("Liquid Top")
			var shader_mat = liquid.material as ShaderMaterial
			var shader_mat2 = liquid_top.material as ShaderMaterial
			shader_mat.set_shader_parameter("tint_color", ingredient_color)
			shader_mat2.set_shader_parameter("tint_color", ingredient_color)
			liquid_top.current_fill = inventory_manager.glass_inventory[target_id]["fill_level"]
			
			shader_mat.set_shader_parameter("fill_amount", inventory_manager.glass_inventory[target_id]["fill_level"]/8.0)
			
		print(contents)
		
		
	if target_type == "Glass" and dragged_type == "Shaker":
		var contents: Dictionary = inventory_manager.tool_inventory[dragged_id]["contents"]
		var fill_level: float = inventory_manager.tool_inventory[dragged_id]["fill_level"]

		inventory_manager.glass_inventory[target_id]["contents"] = contents.duplicate()
		inventory_manager.glass_inventory[target_id]["fill_level"] = fill_level
		if inventory_manager.tool_inventory[dragged_id]["shaken"] == true:
			inventory_manager.glass_inventory[target_id]["prep"] = "Shaken"

		inventory_manager.tool_inventory[dragged_id]["contents"] = {}
		inventory_manager.tool_inventory[dragged_id]["fill_level"] = 0.0
		inventory_manager.tool_inventory[dragged_id]["shaken"] = false
		print(contents)
		
