extends Node2D

var popup_interactions: = {
	["Bottle", "Jigger"]: "Pouring", ["Shaker Lid", "Shaker"]: "Shaking"
}

var pour_interactions: = [["Jigger","Drain"],["Shaker","Drain"],["Glass","Drain"],["Jigger","Shaker"],["Jigger","Glass"],["Shaker","Glass"],
["Scooper","Glass"],["Scooper","Shaker"]]

@onready var popup_manager: CanvasLayer = $"../../PopupManager"
@onready var pour_manager: Node2D = $"../PourManager"
@onready var item_catalogue: Node2D = $"../ItemCatalogue"
@onready var inventory_manager: Node2D = $"../InventoryManager"
@onready var drain: Area2D = $"../../Workstation/Drain"

signal minigame_request(minigame: String)
signal initiate_pour

# --- Snap Grid Parameters ---
var snap_points: Array = []
var snap_origin: Vector2 = Vector2(680, 40)  # Starting top-left corner of grid in pixels
var grid_columns: int = 31
var grid_rows: int = 17
var grid_spacing: Vector2 = Vector2(40, 40)  # Horizontal/vertical spacing between snap points

func _ready():
	connect("minigame_request", Callable(popup_manager, "show_minigame"))
	connect("initiate_pour", Callable(pour_manager, "initiate_pour"))
	
	generate_snap_points()
	
func generate_snap_points() -> void:
	snap_points.clear()
	for row in range(grid_rows):
		for col in range(grid_columns):
			var snap_position = snap_origin + Vector2(col * grid_spacing.x, row * grid_spacing.y)
			snap_points.append(snap_position)

			## Create a small red ColorRect to visualize the snap point
			#var marker := ColorRect.new()
			#marker.color = Color(1, 0, 0, 0.5)  # Semi-transparent red
			#marker.size = Vector2(10, 10)
			#marker.position = position - marker.size / 2  # Centered on the snap point
			#add_child(marker)

func object_interaction(dragged_object: Area2D, target_object: Area2D) -> void:
	
	if dragged_object and target_object:
		var dragged_type = dragged_object.item_type
		var target_type = ""
		if target_object == drain:
			target_type = "Drain"
		else:
			target_type = target_object.item_type
		var key = [dragged_type, target_type]
		print("Interaction: ",dragged_type," -> ",target_type)
		
		var allow_interaction = true
		if check_valid(key,dragged_object,target_object) == false:
			allow_interaction = false
		
		if popup_interactions.has(key) and allow_interaction:
			popup_manager.target_object = target_object
			popup_manager.dragged_object = dragged_object
			emit_signal("minigame_request", popup_interactions[key])
			
		elif pour_interactions.has(key):
			pour_manager.target_object = target_object
			pour_manager.dragged_object = dragged_object
			emit_signal("initiate_pour")
			
		snap_dragged_object_to_valid_position(dragged_object)

func interaction_highlight(dragged_object: Area2D, target_object: Area2D) -> void:
	
	if dragged_object and target_object:
		var dragged_type = dragged_object.item_type
		var target_type = ""
		if target_object == drain:
			target_type = "Drain"
		else:
			target_type = target_object.item_type
		var key = [dragged_type, target_type]
		var sprite = target_object.get_node("Sprite2D")
		
		if check_valid(key,dragged_object,target_object) == false:
			sprite.material.set_shader_parameter("tint_color", Color(1, 0.6, 0.6))
			return
			
		if popup_interactions.has(key) or pour_interactions.has(key):
			sprite.material.set_shader_parameter("tint_color", Color(0.6, 1, 0.6))
		else:
			sprite.material.set_shader_parameter("tint_color", Color(1, 0.6, 0.6))
			
func clear_highlight(target_object: Area2D) -> void:
	if target_object:
		var sprite = target_object.get_node("Sprite2D")
		sprite.material.set_shader_parameter("tint_color", Color(1, 1, 1))
		
func snap_dragged_object_to_valid_position(dragged_object: Area2D) -> void:
	if snap_points.is_empty(): return

	var object_position = dragged_object.global_position
	var sorted_points = snap_points.duplicate()
	sorted_points.sort_custom(func(a, b): return a.distance_to(object_position) < b.distance_to(object_position))

	var shape_node := dragged_object.get_node_or_null("CollisionShape2D")
	var shape: Shape2D = shape_node.shape.duplicate()
	print(shape_node.shape.extents)
	var space_state = get_world_2d().direct_space_state

	for point in sorted_points:
		var query := PhysicsShapeQueryParameters2D.new()
		query.shape = shape
		query.transform = Transform2D(0, point)
		query.collide_with_areas = true
		query.exclude = [dragged_object]
		
		var result = space_state.intersect_shape(query, 10)
		
		var is_blocked = false
		for res in result:
			if res.collider != null and res.collider != dragged_object and res.collider.is_in_group("interactable"):
				is_blocked = true
				break

		if not is_blocked:
			dragged_object.global_position = point
			return
			
func check_valid(key,dragged_object,target_object):
	
	if key == ["Bottle", "Jigger"]:
		var jigger_contents = inventory_manager.tool_inventory[target_object.get_meta("id")]["jigger_contents"]
		var bottle_contents = item_catalogue.bottle_data[dragged_object.get_meta("name")]["type"]
		if jigger_contents != "" and jigger_contents != bottle_contents:
			print("Jigger already contains a different ingredient")
			return false
				
	if key == ["Shaker Lid", "Shaker"]:
		var shaker_contents = inventory_manager.tool_inventory[target_object.get_meta("id")]["contents"]
		var shaken = inventory_manager.tool_inventory[target_object.get_meta("id")]["shaken"]
		if shaken:
			print("Drink already shaken")
			return false
		elif shaker_contents == {}:
			print("No contents")
			return false
	
	
