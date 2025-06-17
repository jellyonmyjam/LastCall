extends CanvasLayer

@onready var well_sections: Array = $"../Well/Sections".get_children()
@onready var buttons := $"Well Sections/VBoxContainer".get_children()

func _ready() -> void:
	for i in buttons.size():
		buttons[i].pressed.connect(func(): switch_section(i))

func switch_section(index: int):
	for i in range(well_sections.size()):
		well_sections[i].visible = (i == index)
		
