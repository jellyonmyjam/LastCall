extends CanvasLayer

var popup: Node2D = null
var target_object: Area2D = null
var dragged_object: Area2D = null
@onready var blur_overlay: ColorRect = $BlurOverlay
@onready var popups := {"Pouring": $PourMinigame}

func _ready():
	set_process_unhandled_input(true)


func show_minigame(minigame_name: String):
	popup = popups.get(minigame_name)
	if popup:
		#Enable popup
		blur_overlay.visible = true
		popup.visible = true
		var viewport_size = get_viewport().get_visible_rect().size
		popup.position = Vector2(viewport_size.x / 2, viewport_size.y * (1.0 / 3.0))
		popup.z_index = 100
		
		#Set popup info
		popup.target_object = target_object
		popup.dragged_object = dragged_object
		popup.start_minigame()
		
		#Disable draggables
		for node in get_tree().get_nodes_in_group("draggable"):
			node.can_drag = false

func _unhandled_input(event: InputEvent) -> void:
	if popup != null and popup.visible:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			hide_minigame()
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var click_pos = event.position
			if popup.get_node("PopupPanel").get_global_rect().has_point(click_pos):
				pass
			else:
				hide_minigame()

func hide_minigame():
	blur_overlay.visible = false
	for popup_items in popups.values():
		popup_items.visible = false
	for node in get_tree().get_nodes_in_group("draggable"):
		node.can_drag = true
