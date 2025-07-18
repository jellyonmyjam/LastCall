extends Node2D

var patron_name = ""
var sequence = []
var orders = []
var step = 0
var section = 0
var order_count = 0
var current_status
var patron_sprite = null
var waiting_to_arrive = false
var waiting_to_exit = false
var current_status_icon = null
var dialogue_ui = null

var status_icons = {
	"Arriving": "res://Sprites/UI/Status Icons/arriving.png",
	"Idle": "res://Sprites/UI/Status Icons/idle.png",
	"Awaiting Order": "res://Sprites/UI/Status Icons/waitingorder.png",
	"Order": "res://Sprites/UI/Status Icons/takingorder.png",
	"Awaiting Drink": "res://Sprites/UI/Status Icons/waitingdrink.png",
	"Drink Received": "res://Sprites/UI/Status Icons/gettingdrink.png",
	"Dialogue": "res://Sprites/UI/Status Icons/dialogue.png",
	"Exiting": "res://Sprites/UI/Status Icons/leaving.png"
}

@onready var shift_manager = get_tree().get_root().get_node("Scene/Scripts/ShiftManager")
@onready var dialogue_manager = get_tree().get_root().get_node("Scene/Scripts/DialogueManager")

func _ready():
	patron_sprite = get_node("Sprite2D")
	dialogue_ui = get_parent().get_node("Dialogue UI")
	

func play_sequence():
	if step >= sequence.size():
		return
		
	current_status = sequence[step]
		
	var texture_path = status_icons[current_status]
	current_status_icon.texture = load(texture_path)
	
	if current_status == "Arriving":
		if shift_manager.current_section == section:
			await patron_sprite.arrive()
			step += 1
			play_sequence()
		else:
			waiting_to_arrive = true
			var arrival_timer = get_tree().create_timer(5.0)
			await arrival_timer.timeout
			
			if waiting_to_arrive:
				waiting_to_arrive = false
				step += 1
				play_sequence()
				
	if current_status == "Awaiting Order":
		sequence.insert(step + 1, "Drink Received")
		sequence.insert(step + 1, "Awaiting Drink")
		sequence.insert(step + 1, "Order")
	
	if current_status == "Order":
		dialogue_manager.queue_dialogue(patron_name, section)
		
	if current_status == "Drink Received":
		dialogue_manager.queue_dialogue(patron_name, section)

	if current_status == "Exiting":
		if shift_manager.current_section == section:
			await patron_sprite.exit()
			shift_manager.patron_exit(patron_name)
			queue_free()
		else:
			waiting_to_exit = true
			var exit_timer = get_tree().create_timer(5.0)
			await exit_timer.timeout
			
			if waiting_to_exit:
				waiting_to_exit = false


func section_changed():
	if waiting_to_arrive:
		waiting_to_arrive = false
		await patron_sprite.arrive()
		step += 1
		play_sequence()
	
	if waiting_to_exit:
		await patron_sprite.exit()
		shift_manager.patron_exit(patron_name)
		queue_free()
		
		
func dialogue_finished():
	#Placeholder logic to advance steps on dialogue finish
	await get_tree().create_timer(2.0).timeout
	if current_status == "Order" or current_status == "Drink Received" or current_status == "Dialogue" or current_status == "Idle":
		step += 1
		play_sequence()


func patron_interacted():
	await dialogue_ui.clear_bubbles()
	
	if current_status == "Awaiting Order":
		step += 1
		play_sequence()
	if current_status == "Dialogue" or current_status == "Idle":
		dialogue_manager.queue_dialogue(patron_name, section)
		

func drink_served(_score):
	if current_status == "Awaiting Drink":
		step += 1
		play_sequence()
