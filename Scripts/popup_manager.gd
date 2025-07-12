extends CanvasLayer

var popup: PackedScene = null
var popup_instance = null
var target_object: Area2D = null
var dragged_object: Area2D = null
@onready var blur_overlay: ColorRect = $BlurOverlay
const pour_minigame = preload("res://Scenes/UI/pour_minigame.tscn")
const pour_minigame_glass = preload("res://Scenes/UI/pour_minigame_glass.tscn")
const shaker_minigame = preload("res://Scenes/UI/shaker_minigame.tscn")
@onready var popups := {"Pouring": pour_minigame, "Pouring Glass": pour_minigame_glass, "Shaking": shaker_minigame}


func _ready():
	set_process_unhandled_input(true)

func show_minigame(minigame_name: String):
	popup = popups.get(minigame_name)
	if popup:
		blur_overlay.visible = true
		popup_instance = popup.instantiate()
		add_child(popup_instance)
		var viewport_size = get_viewport().get_visible_rect().size
		popup_instance.position = Vector2(viewport_size.x / 2, viewport_size.y / 2)
		popup_instance.z_index = 100
		
		if popup_instance.name == "Shaker Minigame":
			var knob = popup_instance.get_node("Knob")
			knob.target_object = target_object
			knob.dragged_object = dragged_object
			knob.start_minigame()
		else:
			popup_instance.target_object = target_object
			popup_instance.dragged_object = dragged_object
			popup_instance.start_minigame()
		
		#Disable draggables
		for node in get_tree().get_nodes_in_group("draggable"):
			node.can_drag = false

func _unhandled_input(event: InputEvent) -> void:
	if popup_instance != null:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			hide_minigame()
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var click_pos = event.position
			if popup_instance.get_node("PopupPanel").get_global_rect().has_point(click_pos):
				pass
			else:
				hide_minigame()

func hide_minigame():
	blur_overlay.visible = false
	popup_instance.queue_free()
	popup_instance = null
	for node in get_tree().get_nodes_in_group("draggable"):
		node.can_drag = true
