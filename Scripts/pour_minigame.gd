extends Node2D

@onready var bottle: Area2D = $"PopupPanel/MinigameContent/Bottle Minigame"
@onready var bottle_sprite: Sprite2D = $"PopupPanel/MinigameContent/Bottle Minigame/Sprite2D"
@onready var fill_meter: ProgressBar = $PopupPanel/FillMeter

# These are your bottle pour thresholds
const pour_start_angle = deg_to_rad(0.0)
const max_angle = deg_to_rad(-75)

# Fill speed multiplier — tweak this to tune how fast it fills
const pour_rate_multiplier = 1.0  # units per second at full tilt

var max_fill = 2.0
var current_fill := 0.0
var target_object: Area2D = null
var dragged_object: Area2D = null
var ingredient = ""
var bottle_id = 0
var bottle_index
var bottle_fill
var item_catalogue: Node2D = null
var inventory_manager: Node2D = null

func _ready():
	item_catalogue = get_tree().root.get_node("Scene/Scripts/ItemCatalogue")
	inventory_manager = get_tree().root.get_node("Scene/Scripts/InventoryManager")
	fill_meter.max_value = 1.0
	
func start_minigame():
	current_fill = inventory_manager.tool_inventory[target_object.get_meta("id")]["fill_level"]
	bottle_id = dragged_object.get_meta("id")
	ingredient = item_catalogue.bottle_data[dragged_object.get_meta("name")]["type"]
	inventory_manager.tool_inventory[target_object.get_meta("id")]["jigger_contents"] = ingredient
	bottle_fill = inventory_manager.bottle_inventory[bottle_id]["fill_level"]
	var bottle_texture = item_catalogue.bottle_data[dragged_object.get_meta("name")]["texture_well"]
	bottle_sprite.texture = bottle_texture

func _process(delta):

	var angle = bottle.rotation
	var pour_speed = get_pour_speed(angle)
	var delta_fill = pour_speed * pour_rate_multiplier * delta
	
	if current_fill + delta_fill > max_fill:
		delta_fill = max_fill - current_fill
	
	current_fill += delta_fill
	fill_meter.value = current_fill / max_fill
	inventory_manager.tool_inventory[target_object.get_meta("id")]["fill_level"] = current_fill
	
	bottle_fill = max(bottle_fill - delta_fill, 0.0)
	inventory_manager.bottle_inventory[bottle_id]["fill_level"] = bottle_fill

func get_pour_speed(angle: float) -> float:
	if angle > pour_start_angle:
		return 0.0
	return clamp((pour_start_angle - angle) / (pour_start_angle - max_angle), 0.0, 1.0)
