extends CanvasLayer

@onready var buttons := $"Patron Panel/HBoxContainer".get_children()
@onready var wall: Sprite2D = $"../Dialogue/Wall"
@onready var patron_sections: Array = $"../Dialogue/Patron Sections".get_children()
@onready var snap_points: Array = $"../Dialogue/Snap Points Serve".get_children()
@onready var serve_manager: Node2D = $"../Scripts/ServeManager"

var background_positions = [604,604,604,315,34,34,34,34]

func _ready() -> void:
	for i in buttons.size():
		var index := i  # Capture i in a new local variable
		buttons[i].pressed.connect(func(): switch_section(index))

func switch_section(index: int) -> void:
	serve_manager.current_section = index
	
	for i in patron_sections.size():
		patron_sections[i].visible = (i == index)
	for i in snap_points.size():
		snap_points[i].visible = (i == index)
		
	var new_x = background_positions[index]
	var current_pos = wall.position
	wall.position = Vector2(new_x, current_pos.y)
