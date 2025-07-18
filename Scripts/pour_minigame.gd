extends Node2D

@onready var bottle: Area2D = $"PopupPanel/MinigameContent/Bottle Minigame"
@onready var bottle_sprite: Sprite2D = $"PopupPanel/MinigameContent/Bottle Minigame/Sprite2D"
@onready var fill_meter: ProgressBar = $PopupPanel/FillMeter

const pour_start_angle = deg_to_rad(0.0)
const max_angle = deg_to_rad(-75)

const pour_rate_multiplier = 1.0  # units per second at full tilt
const pour_lag = 5.0 # delay between changing angle and change in pour speed

var liquid: Sprite2D = null
var liquid_well: Sprite2D = null
var liquid_workstation: Sprite2D = null
var max_fill = 2.0
var current_fill := 0.0
var target_object: Area2D = null
var dragged_object: Area2D = null
var ingredient = ""
var ingredient_name = ""
var ingredient_color = null
var bottle_id = null
var target_id = null
var bottle_index
var bottle_fill
var item_catalogue: Node2D = null
var inventory_manager: Node2D = null
var smoothed_pour_speed = 0.0

func _ready():
	item_catalogue = get_tree().root.get_node("Scene/Scripts/ItemCatalogue")
	inventory_manager = get_tree().root.get_node("Scene/Scripts/InventoryManager")
	fill_meter.max_value = 1.0
	
	if name == "Pour Minigame":
		max_fill = 2.0
	if name == "Pour Minigame Glass":
		max_fill = 8.0
		liquid = $"PopupPanel/MinigameContent/Glass Minigame/Sprite2D/Liquid"

	
func start_minigame():
	bottle_id = dragged_object.get_meta("id")
	target_id = target_object.get_meta("id")
	ingredient = item_catalogue.bottle_data[dragged_object.get_meta("name")]["type"]
	ingredient_color = item_catalogue.bottle_data[dragged_object.get_meta("name")]["color"]
	bottle_fill = inventory_manager.bottle_inventory[bottle_id]["fill_level"]
	var bottle_texture = item_catalogue.bottle_data[dragged_object.get_meta("name")]["texture_well"]
	bottle_sprite.texture = bottle_texture
	
	if name == "Pour Minigame":
		current_fill = inventory_manager.tool_inventory[target_id]["fill_level"]
		inventory_manager.tool_inventory[target_id]["jigger_contents"] = ingredient
		inventory_manager.tool_inventory[target_id]["contents_name"] = dragged_object.get_meta("name")
	
	if name == "Pour Minigame Glass":
		current_fill = inventory_manager.glass_inventory[target_id]["fill_level"]
		var glass_sprite = $"PopupPanel/MinigameContent/Glass Minigame/Sprite2D"
		liquid_well = target_object.get_node("Sprite2D").get_node("Liquid")
		liquid_workstation = target_object.get_node("Sprite2D").get_node("Liquid Top")
		var glass_texture = target_object.texture_well
		glass_sprite.texture = glass_texture
		var glass_type = inventory_manager.glass_inventory[target_id]["type"]
		var liquid_texture = item_catalogue.glass_data[glass_type]["texture_liquid"]
		liquid.texture = liquid_texture
		glass_sprite.position.y = item_catalogue.glass_data[glass_type]["minigame_offset"]
		liquid.position = item_catalogue.glass_data[glass_type]["liquid_offset"]
		
		
func _process(delta):

	var angle = bottle.rotation
	var pour_speed = get_pour_speed(angle, delta)
	var delta_fill = pour_speed * pour_rate_multiplier * delta
	
	if current_fill + delta_fill > max_fill:
		delta_fill = max_fill - current_fill
	
	current_fill += delta_fill
	fill_meter.value = current_fill / max_fill
	bottle_fill = max(bottle_fill - delta_fill, 0.0)
	
	if name == "Pour Minigame":
		inventory_manager.tool_inventory[target_id]["fill_level"] = current_fill
		
	elif name == "Pour Minigame Glass":
		var contents = inventory_manager.glass_inventory[target_id]["contents"]
		if contents.has(ingredient):
			contents[ingredient] += delta_fill
		else:
			contents[ingredient] = delta_fill
		inventory_manager.glass_inventory[target_id]["contents"] = contents
		inventory_manager.glass_inventory[target_id]["fill_level"] = current_fill
		
		var shader_mat = liquid.material as ShaderMaterial
		var shader_mat2 = liquid_well.material as ShaderMaterial
		var shader_mat3 = liquid_workstation.material as ShaderMaterial
		var raw_fill_ratio = clamp(current_fill / max_fill, 0.0, 1.0)
		var visual_fill = lerp(0.0, 1.0, raw_fill_ratio)
		shader_mat.set_shader_parameter("fill_amount", visual_fill)
		shader_mat.set_shader_parameter("tint_color", ingredient_color)
		shader_mat2.set_shader_parameter("fill_amount", visual_fill)
		shader_mat2.set_shader_parameter("tint_color", ingredient_color)
		liquid_workstation.current_fill = current_fill
		shader_mat3.set_shader_parameter("tint_color", ingredient_color)
			
		
	inventory_manager.bottle_inventory[bottle_id]["fill_level"] = bottle_fill


func get_pour_speed(angle: float, delta: float) -> float:
	var target_speed := 0.0
	if angle <= pour_start_angle:
		target_speed = clamp((pour_start_angle - angle) / (pour_start_angle - max_angle), 0.0, 1.0)
	
	smoothed_pour_speed = lerp(smoothed_pour_speed, target_speed, delta * pour_lag)
	return smoothed_pour_speed
