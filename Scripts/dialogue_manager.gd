extends Node2D

@onready var patron_data: Node2D = $"../PatronData"
@onready var patron_sections: Array = $"../../Dialogue/Patron Sections".get_children()

var active_ui = null
var session_id = 0


func queue_dialogue(patron, index):
	session_id += 1
	var current_id = session_id
	
	var patron_object = patron_sections[index].get_node("Patron")
	var patron_status = patron_object.current_status
	
	var dialogue_path = patron_data.patron_profiles[patron]["dialogue file"]
	active_ui = patron_sections[index].get_node("Dialogue UI")
	var file = FileAccess.open(dialogue_path, FileAccess.READ)
		
	var parsed_lines = []
	var headers = []
	var line_number = 0
	
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if line == "":
			continue
	
		#var split = []
		#var current = ""
		#var inside_quotes = false
		
		var split = line.split(",")

		#for i in line.length():
			#var character = line[i]
			#if character == '"':
				#inside_quotes = !inside_quotes
			#elif character == ',' and not inside_quotes:
				#split.append(current.strip_edges())
				#current = ""
			#else:
				#current += character
		#split.append(current.strip_edges())
		
		if line_number == 0:
			headers = split
		else:
			var entry = {}
			for i in headers.size():
				if i < split.size():
					entry[headers[i].strip_edges()] = split[i].strip_edges()
					
			if entry.has("State") and entry["State"] == patron_status:
				parsed_lines.append(entry)
			
		line_number += 1

	play_dialogue_sequence(parsed_lines, current_id, patron_object)


func play_dialogue_sequence(lines: Array, current_id: int, patron_object: Node2D) -> void:
	var current_playing_ui = active_ui
	
	for entry in lines:
		if current_id == session_id:
			var is_player = entry["Speaker"] == "Player"
			current_playing_ui.create_text(is_player, entry["Text"])
			await get_tree().create_timer(1.0).timeout
		else:
			return
	
	if current_id == session_id:
		patron_object.dialogue_finished()
		
