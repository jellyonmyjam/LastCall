extends Node2D

@onready var patron_sections: Array = $"../../Dialogue/Patron Sections".get_children()
@onready var patron_data: Node2D = $"../PatronData"
const patron_scene = preload("res://Scenes/patron.tscn")

var starting_positions = ["","","Carol","Bill","Jimbo","","",""]


func _ready() -> void:
	for i in starting_positions.size():
		var patron_name = starting_positions[i]
		if patron_name != "":
			var patron_instance = patron_scene.instantiate()
			patron_sections[i].add_child(patron_instance)
			patron_instance.position = Vector2(300, 450)
			
			var patron_sprite = patron_instance.get_node("Sprite2D")
			print(patron_sprite)
			var texture_path = patron_data.patron_profiles[patron_name]["texture"]
			print(texture_path)
			var patron_size = patron_data.patron_profiles[patron_name]["size"]
			print(patron_size)
			patron_sprite.texture = load(texture_path)
			patron_sprite.scale = patron_size
