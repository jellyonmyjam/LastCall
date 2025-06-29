extends Area2D

var last_state = false
var can_pour
@onready var snap_point_soda: Node2D = $"Snap Points Soda/Snap Point"
@onready var objects: Node2D = $"../Objects"
@onready var inventory_manager: Node2D = $"../../../../Scripts/InventoryManager"

		
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if snap_point_soda.get_meta("Occupied") == true:
			pour_soda()
		
func pour_soda():
	for object in objects.get_children():
		if "current_snap_point" in object and object.current_snap_point:
			if object.current_snap_point == snap_point_soda:
				var id = object.get_meta("id")
				if inventory_manager.glass_inventory[id]["has_soda"] == false:
					inventory_manager.glass_inventory[id]["has_soda"] = true
					break
				else:
					print("glass already contains soda")
