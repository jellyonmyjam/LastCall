extends Node2D

@onready var patron_sections: Array = $"../../Dialogue/Patron Sections".get_children()
@onready var patron_data: Node2D = $"../PatronData"
@onready var dialogue_manager: Node2D = $"../DialogueManager"
@onready var buttons: Array = $"../../PatronManager/Patron Panel/HBoxContainer".get_children()
@onready var interact_button: Button = $"../../PatronManager/Patron Panel/Interact Button"

const patron_scene = preload("res://Scenes/patron.tscn")

var positions = ["","","","","","","",""]
var arrival_queue = []
var current_section = null
var time_count = 0

var shift_script = [
	{"Patron": "Carol", "Slot": 3, "Delay": 0, "Sequence": ["Awaiting Order","Idle","Exiting"], "Orders": ["Daiquiri"]},
	{"Patron": "Bill", "Slot": 4, "Delay": 0, "Sequence": ["Awaiting Order","Dialogue","Idle"], "Orders": ["Vodka Fizz"]},
	{"Patron": "Jimbo", "Slot": 6, "Delay": 2, "Sequence": ["Arriving","Awaiting Order","Idle"], "Orders": ["Whiskey on the Rocks"]}
]

func _ready() -> void:
	for entry in shift_script:
		if entry["Delay"] == 0:
			positions[entry["Slot"]-1] = entry["Patron"]
		else:
			arrival_queue.append(entry["Patron"])
	
	for i in positions.size():
		var patron_name = positions[i]
		if patron_name != "":
			spawn_patron(patron_name,i)
			
	interact_button.pressed.connect(interact_pressed)
	arrivals()


func spawn_patron(patron_name, index):
	var patron_instance = patron_scene.instantiate()
	patron_instance.section = index
	patron_instance.patron_name = patron_name
	patron_sections[index].add_child(patron_instance)
	patron_instance.position = Vector2(300, 450)
	var patron_sprite = patron_instance.get_node("Sprite2D")
	var texture_path = patron_data.patron_profiles[patron_name]["texture"]
	var patron_size = patron_data.patron_profiles[patron_name]["size"]
	patron_sprite.texture = load(texture_path)
	patron_sprite.scale = patron_size
			
	buttons[index].icon = preload("res://Sprites/UI/character.png")
	
	for entry in shift_script:
		if entry["Patron"] == patron_name:
			patron_instance.sequence = entry["Sequence"]
			patron_instance.orders = entry["Orders"]
			break
	
	patron_instance.current_status_icon = buttons[index].get_node("Status Icon")
	buttons[index].get_node("Status Icon").visible = true
	
	patron_instance.play_sequence()


func interact_pressed():
	if positions[current_section] != "":
		#dialogue_manager.queue_dialogue(positions[current_section], current_section)
		var patron = patron_sections[current_section].get_node("Patron")
		patron.patron_interacted()
		

func arrivals():
	while true:
		await get_tree().create_timer(5.0).timeout
		time_count += 1
		var to_remove = []
		
		for i in arrival_queue.size():
			var patron = arrival_queue[i]
			for entry in shift_script:
				if entry["Patron"] == patron and entry["Delay"] <= time_count:
					positions[entry["Slot"]-1] = patron
					spawn_patron(patron, entry["Slot"]-1)
					to_remove.append(patron)
					break
		
		for patron in to_remove:
			arrival_queue.erase(patron)


func switch_to_panel():
	if patron_sections[current_section].has_node("Patron"):
		var patron = patron_sections[current_section].get_node("Patron")
		dialogue_manager.session_id += 1
		patron.section_changed()
	

func patron_exit(patron_name):
	var slot = 0
	
	for i in range(positions.size()):
		if positions[i] == patron_name:
			slot = i
			positions[i] = ""
			break
	
	buttons[slot].icon = preload("res://Sprites/UI/blank.png")
	var status_icon = buttons[slot].get_node("Status Icon")
	status_icon.visible = false
	
	
	
