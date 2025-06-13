extends Area2D

@export var scooper_scene: PackedScene
@onready var snap_points: Node2D = $"Snap Points"
@onready var snap_point: Node2D = $"Snap Points/Snap Point"
@onready var objects: Node2D = $"../Objects"
@export var texture_with_scooper: Texture2D
@export var texture_without_scooper: Texture2D
@onready var sprite := $Sprite2D
var scooper_instance = null

var scooper_exists = false

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and scooper_exists == false:
		spawn_scooper()
		
func spawn_scooper():
	scooper_instance = scooper_scene.instantiate()
	objects.add_child(scooper_instance)
	scooper_instance.global_position = snap_point.global_position
	scooper_instance.snap_points = snap_points
	scooper_instance.current_snap_point = snap_point
	scooper_exists = true
	sprite.texture = texture_without_scooper

	await get_tree().process_frame  # Ensure it's fully added to scene
	scooper_instance.start_drag()
	
func _process(_delta):
	if scooper_exists and snap_point.get_meta("Occupied") == true:
		scooper_instance.queue_free()
		scooper_instance = null
		scooper_exists = false
		snap_point.set_meta("Occupied", false)
		sprite.texture = texture_with_scooper
