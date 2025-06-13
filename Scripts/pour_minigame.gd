extends Node2D

@onready var bottle: Area2D = $"PopupPanel/MinigameContent/Bottle Minigame"
@onready var fill_meter: ProgressBar = $PopupPanel/FillMeter
@onready var interaction_manager: Node2D = $"../../InteractionManager"

# These are your bottle pour thresholds
const pour_start_angle = deg_to_rad(0.0)
const max_angle = deg_to_rad(-75)

# Fill speed multiplier — tweak this to tune how fast it fills
const pour_rate_multiplier = 50.0  # units per second at full tilt
const max_fill = 100.0

var current_fill := 0.0
var target_object: Area2D = null
var dragged_object: Area2D = null
var ingredient = ""

func start_minigame():
	current_fill = target_object.get_meta("Fill_Level")
	ingredient = dragged_object.get_meta("Bottle_Contents")
	target_object.set_meta("Jigger_Contents", ingredient)

func _process(delta):
	if not visible:
		return

	var angle = bottle.rotation
	var pour_speed = get_pour_speed(angle)
	var delta_fill = pour_speed * pour_rate_multiplier * delta
	
	if current_fill + delta_fill > max_fill:
		delta_fill = max_fill - current_fill
	
	current_fill += delta_fill
	fill_meter.value = current_fill
	target_object.set_meta("Fill_Level", current_fill)
	
	var bottle_fill = dragged_object.get_meta("Fill_Level")
	bottle_fill = max(bottle_fill - delta_fill, 0.0)
	dragged_object.set_meta("Fill_Level", bottle_fill)

func get_pour_speed(angle: float) -> float:
	if angle > pour_start_angle:
		return 0.0
	return clamp((pour_start_angle - angle) / (pour_start_angle - max_angle), 0.0, 1.0)
