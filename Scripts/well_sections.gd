extends CanvasLayer

@onready var well_sections: Array = $"../Well/Sections".get_children()
@onready var buttons := $"Well Sections/VBoxContainer".get_children()

func _ready() -> void:
	for i in buttons.size():
		buttons[i].pressed.connect(func(): switch_section(i))
		
	for i in range(well_sections.size()):
		if well_sections[i].visible:
			switch_section(i)
			break

func switch_section(index: int):
	for i in range(well_sections.size()):
		well_sections[i].visible = (i == index)
	for i in range(buttons.size()):
		buttons[i].modulate = Color(0.75, 0.85, 0.75) if i == index else Color(1,1,1)
