extends Node2D

var hover_timer = null
var hovered_object = null
var bottle_description = preload("res://Scenes/UI/bottledescription.tscn")
var active_description = null
@onready var item_catalogue: Node2D = $"../ItemCatalogue"
@onready var inventory_manager: Node2D = $"../InventoryManager"


func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if hover_timer:
			hover_timer.queue_free()
			hover_timer = null
			
		if active_description:
			active_description.queue_free()
			active_description = null

func on_hover_entered(object):
	if object.item_type != "Bottle":
		return
	if object.last_area != "Well":
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
		
	hovered_object = object
	var id = object.get_meta("id")
	var bottle_name = object.get_meta("name")
	
	if hover_timer:
		hover_timer.queue_free()
		
	hover_timer = Timer.new()
	hover_timer.wait_time = 0.5
	hover_timer.one_shot = true
	add_child(hover_timer)
	hover_timer.start()
	await hover_timer.timeout
	
	if hovered_object == object and active_description == null:
		active_description = bottle_description.instantiate()
		active_description.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/Name").text = bottle_name
		active_description.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer/Type").text = item_catalogue.bottle_data[bottle_name]["type"]
		active_description.get_node("Panel/MarginContainer/VBoxContainer/Description").text = item_catalogue.bottle_data[bottle_name]["description"]
		var fill = inventory_manager.bottle_inventory[id]["fill_level"]
		var max_fill = item_catalogue.bottle_data[bottle_name]["volume"]
		active_description.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer2/Fill").text = str(int(round(fill))) + "/" + str(int(round(max_fill)))
		active_description.get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer2/ProgressBar").value = fill / max_fill * 100
		add_child(active_description)
		active_description.global_position = get_global_mouse_position() + Vector2(40, -200)


func on_hover_exited(object):
	if hovered_object == object:
		hovered_object = null
	
	if hover_timer:
		hover_timer.queue_free()
		hover_timer = null
			
	if active_description:
		active_description.queue_free()
		active_description = null
	
