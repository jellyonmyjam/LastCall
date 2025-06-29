extends Node2D

var last_state = false
var order = "Daiquiri"
var snap_position = null
@onready var serve_button: Button = $"../../DialogueUI/ServeButton"
@onready var snap_point_serve: Node2D = $"../../Dialogue/Snap Points Serve/Snap Point"
@onready var objects: Node2D = $"../../Dialogue/Objects"
@onready var inventory_manager: Node2D = $"../InventoryManager"
@onready var dialogue_ui: Control = $"../../DialogueUI"
@onready var recipe_catalogue: Node2D = $"../RecipeCatalogue"


func _ready():
	serve_button.pressed.connect(serve_drink)
	snap_position = snap_point_serve.global_position

func _process(_delta):
	for object in objects.get_children():
		if object.item_type == "Glass" and object.global_position.distance_to(snap_position) < 1:
			serve_button.visible = true
		else:
			serve_button.visible = false

func serve_drink():
	for object in objects.get_children():
		if "current_snap_point" in object and object.current_snap_point:
			if object.current_snap_point == snap_point_serve:
				var id = object.get_meta("id")
				var contents = inventory_manager.glass_inventory[id]["contents"]
				var glass_type = inventory_manager.glass_inventory[id]["type"]
				var prep = inventory_manager.glass_inventory[id]["prep"]
				var has_ice = inventory_manager.glass_inventory[id]["has_ice"]
				var has_soda = inventory_manager.glass_inventory[id]["has_soda"]
				var score = score_drink(contents,glass_type,prep,has_ice,has_soda)
				print(score)
				object.queue_free()
				break

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
			
		
	
