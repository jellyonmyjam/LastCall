extends Area2D

var is_minigame_visible := false
var rotating := false
var angle_offset := 0.0
const min_angle := deg_to_rad(15)
const max_angle := deg_to_rad(-75)
@onready var pour_minigame: Node2D = $"../../.."

func reset_rotation():
	rotation = min_angle
	rotating = false

func _process(_delta):
	if is_minigame_visible and not pour_minigame.visible:
		reset_rotation()
		
	is_minigame_visible = pour_minigame.visible

func _input_event(_viewport, event, _shape_idx):
	if not pour_minigame.visible:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		rotating = true
		var mouse_pos = get_global_mouse_position()
		angle_offset = rotation - (mouse_pos - global_position).angle()

func _unhandled_input(event):
	if not pour_minigame.visible:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		rotating = false

	elif event is InputEventMouseMotion and rotating:
		var mouse_pos = get_global_mouse_position()
		var angle = (mouse_pos - global_position).angle() + angle_offset
		rotation = clamp(angle, max_angle, min_angle)
