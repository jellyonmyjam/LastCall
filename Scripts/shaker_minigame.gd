extends Area2D

var dragging := false
var offset := Vector2()
var zones = []
var hit_zones = []
var last_side = null
var dragged_object = null
var target_object = null
var inventory_manager = null
var popup_manager = null

@onready var bar := get_parent().get_node("Bar")
@onready var shaker := get_parent().get_node("Shaker")
@onready var shake_meter := get_parent().get_node("ShakeMeter")
@onready var left_score := get_parent().get_node("LeftScore")
@onready var right_score := get_parent().get_node("RightScore")


func _ready():
	inventory_manager = get_tree().root.get_node("Scene/Scripts/InventoryManager")
	popup_manager = get_tree().root.get_node("Scene/PopupManager")
	for zone in bar.get_children():
		zones.append(zone)
		
func start_minigame():
	pass
	
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				offset = global_position - get_global_mouse_position()
			else:
				dragging = false

func _process(_delta):
	if dragging:
		var mouse_pos = get_global_mouse_position() + offset
		
		# Get bar's global rect
		var bar_global_pos = bar.get_global_position()
		var bar_size = bar.size
		var min_x = bar_global_pos.x
		var max_x = bar_global_pos.x + bar_size.x
		var min_y = bar_global_pos.y
		var max_y = bar_global_pos.y + bar_size.y

		# Clamp the object's position within the bar
		mouse_pos.x = clamp(mouse_pos.x, min_x, max_x)
		mouse_pos.y = clamp(mouse_pos.y, min_y, max_y)
		
		global_position = mouse_pos
		shaker.global_position = mouse_pos + Vector2(0,-250)
		
		# Track which zone we're in
		for zone in range(zones.size()):
			if zones[zone].get_global_rect().has_point(global_position):
				if zone not in hit_zones:
					hit_zones.append(zone)
				# If in center zone
				if zone == 4 and hit_zones.size() > 1:
					handle_zone_trip()
				break
				
				
func handle_zone_trip():
	var priority_groups = [
		["1", "8"],
		["2", "7"],
		["3", "6"],
		["4", "5"]
	]
	
	var current_side = null

	for group in priority_groups:
		for zone_index in hit_zones:
			var zone_name = zones[zone_index].name
			var score = ""
			var color = Color(0,0,0)
			if zone_name in group:
				var zone_num = int(zone_name)
				if zone_num <= 4:
					current_side = "left"
				elif zone_num > 4:
					current_side = "right"
				else:
					continue
				
				if last_side == null or current_side != last_side:
					print("Furthest zone: " + str(zone_name))
					if zone_num in [1, 8]:
						score = "Miss"
						color = Color(1,0,0)
					elif zone_num in [2,4,5,7]:
						score = "Good"
						color = Color(0,1,0)
						shake_meter.value += 4
					elif zone_num in [3,6]:
						score = "Perfect"
						color = Color(0,0,1)
						shake_meter.value += 8
					if current_side == "right":
						right_score.text = score
						right_score.modulate.a = 1.0
						right_score.add_theme_color_override("font_color", color)
						fade_out_label(right_score)
						left_score.text = ""
						left_score.modulate.a = 0.0
					elif current_side == "left":
						left_score.text = score
						left_score.modulate.a = 1.0
						left_score.add_theme_color_override("font_color", color)
						fade_out_label(left_score)
						right_score.text = ""
						right_score.modulate.a = 0.0
					last_side = current_side
					if shake_meter.value >= 100:
						minigame_complete()
				hit_zones.clear()
				return
				
func fade_out_label(label: Label):
	var tween := create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 1.2).from(1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
func minigame_complete():
	var target_id = target_object.get_meta("id")
	inventory_manager.tool_inventory[target_id]["shaken"] = true
	popup_manager.hide_minigame()
		
	
	
