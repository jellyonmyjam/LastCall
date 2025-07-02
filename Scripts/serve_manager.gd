extends Node2D

var order = "Daiquiri"
var serve_buttons = []
var current_section = 0
var drink_ready = null

@onready var snap_points_serve: Array = $"../../Dialogue/Snap Points Serve".get_children()
@onready var patron_sections: Array = $"../../Dialogue/Patron Sections".get_children()
@onready var inventory_manager: Node2D = $"../InventoryManager"
@onready var recipe_catalogue: Node2D = $"../RecipeCatalogue"


func _ready():
	for i in range(patron_sections.size()):
		var serve_button = patron_sections[i].get_node("Serve UI/Serve Button")
		serve_buttons.append(serve_button)
		serve_button.pressed.connect(serve_drink)
		
		if patron_sections[i].visible:
			current_section = i

func _process(_delta):
	var section = patron_sections[current_section]
	var snap_point = snap_points_serve[current_section]
	var serve_button = serve_buttons[current_section]
	var snap_position = snap_point.global_position
	var found_glass = false
	
	for object in section.get_children():
		if object.has_method("get"):
			if "item_type" in object and object.item_type == "Glass":
				if object.global_position.distance_to(snap_position) < 1:
					found_glass = true
					drink_ready = object
					break
	
	serve_button.visible = found_glass


func serve_drink():
	var id = drink_ready.get_meta("id")
	var contents = inventory_manager.glass_inventory[id]["contents"]
	var glass_type = inventory_manager.glass_inventory[id]["type"]
	var prep = inventory_manager.glass_inventory[id]["prep"]
	var has_ice = inventory_manager.glass_inventory[id]["has_ice"]
	var has_soda = inventory_manager.glass_inventory[id]["has_soda"]
	var score = score_drink(contents,glass_type,prep,has_ice,has_soda)
	print(score)
	drink_ready.queue_free()
	snap_points_serve[current_section].set_meta("Occupied", false)


func score_drink(contents,glass_type,prep,has_ice,has_soda):
	print("Contents: ", contents)
	print("Prep: ", prep)
	print("Ice: ", has_ice)
	print("Soda: ", has_soda)
	
	var order_contents = recipe_catalogue.recipes[order]["ingredients"]
	var score = 0.0
	var total_score = 0.0
	
	for ingredient in order_contents:
		var expected = order_contents[ingredient]
		if contents.has(ingredient):
			var actual = contents[ingredient]
			var ingredient_score = 10 - abs(actual - expected) / expected * 10
			score += ingredient_score
		total_score += 10
	
	if recipe_catalogue.recipes[order]["soda"] == true:
		total_score += 20
		if has_soda:
			score += 20
	
	score = (score/total_score) * 70

	for ingredient in contents:
		if not order_contents.has(ingredient):
			score -= contents[ingredient] * 20
			
	if recipe_catalogue.recipes[order]["soda"] == false:
		if has_soda:
			score -= 20
	
	if prep == recipe_catalogue.recipes[order]["prep"]:
		score += 10
	if glass_type == recipe_catalogue.recipes[order]["glass"]:
		score += 10
	if has_ice == recipe_catalogue.recipes[order]["ice"]:
		score += 10
		
	return clamp(score, 0, 100)
			
		
	
