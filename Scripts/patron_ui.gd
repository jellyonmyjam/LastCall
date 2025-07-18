extends CanvasLayer

@onready var buttons: Array = $"Patron Panel/HBoxContainer".get_children()
@onready var wall: Sprite2D = $"../Dialogue/Wall"
@onready var patron_sections: Array = $"../Dialogue/Patron Sections".get_children()
@onready var snap_points: Array = $"../Dialogue/Snap Points Serve".get_children()
@onready var serve_manager: Node2D = $"../Scripts/ServeManager"
@onready var shift_manager: Node2D = $"../Scripts/ShiftManager"
@onready var interact_button: Button = $"Patron Panel/Interact Button"
@onready var dialogue_manager: Node2D = $"../Scripts/DialogueManager"

var background_positions = [604,604,604,315,34,34,34,34]
var starting_slot = 3
var current_section = 0
var can_interact = false
var can_switch = true

func _ready() -> void:
	interact_button.pressed.connect(interact_pressed)
	
	current_section = starting_slot
	serve_manager.current_section = starting_slot
	shift_manager.current_section = starting_slot
	
	for i in buttons.size():
		var index = i  
		buttons[i].pressed.connect(func(): switch_section(index))
		
	for i in patron_sections.size():
		patron_sections[i].visible = (i == starting_slot)
	for i in snap_points.size():
		snap_points[i].visible = (i == starting_slot)
	for i in buttons.size():
		buttons[i].modulate = Color(0.75, 0.85, 0.75) if i == starting_slot else Color(1,1,1)
		
	var new_x = background_positions[starting_slot]
	var current_pos = wall.position
	wall.position = Vector2(new_x, current_pos.y)
	

func _process(_delta):
	if patron_sections[current_section].has_node("Patron"):
		var active_patron = patron_sections[current_section].get_node("Patron")
		var patron_status = active_patron.current_status
		
		if patron_status in ["Arriving", "Order", "Drink Received", "Exiting"]:
			can_interact = false
		elif patron_status == "Dialogue" and dialogue_manager.dialogue_playing:
			can_interact = false
			can_switch = false
		else:
			can_interact = true
			can_switch = true
			
		if patron_status in ["Order", "Drink Received"]:
			can_switch = false
			
	else:
		can_interact = false
		can_switch = true
	
	interact_button.modulate = Color(0.75, 0.85, 0.75) if can_interact else Color(1, 1, 1)
	


func switch_section(index: int) -> void:
	if can_switch:
		current_section = index
		serve_manager.current_section = index
		shift_manager.current_section = index
	
		for i in patron_sections.size():
			patron_sections[i].visible = (i == index)
			var dialogue = patron_sections[i].get_node("Dialogue UI")
			dialogue.clear_bubbles()
		for i in snap_points.size():
			snap_points[i].visible = (i == index)
		for i in buttons.size():
			buttons[i].modulate = Color(0.75, 0.85, 0.75) if i == index else Color(1,1,1)
		
		var new_x = background_positions[index]
		var current_pos = wall.position
		wall.position = Vector2(new_x, current_pos.y)
	
		shift_manager.switch_to_panel()
	
	
func interact_pressed():
	if can_interact:
		patron_sections[current_section].get_node("Patron").patron_interacted()
