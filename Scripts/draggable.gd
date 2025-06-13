extends Area2D

var dragging = false
var can_drag = true
var offset = Vector2()
var last_area := ""
var snap_threshold = 50.0
var original_position = Vector2()
static var dragged_object: Area2D = null
var overlapped_object: Area2D = null
var previous_overlap: Area2D = null
var has_been_initialized = false
var can_snap = false
var previous_snap_point: Node2D = null
var saved_snap_point: Node2D = null
var detach_origin: Vector2

signal interaction_request(dragged_object: Area2D, target_object: Area2D)
signal object_hover(dragged_object: Area2D, target_object: Area2D)
signal cleared_hover(target_object: Area2D)

@onready var well: Area2D = get_tree().get_root().get_node("Scene/Well")
@onready var workstation: Area2D = get_tree().get_root().get_node("Scene/Workstation")
@onready var dialogue: Area2D = get_tree().get_root().get_node("Scene/Dialogue")
@export var snap_points: Node2D
@export var current_snap_point: Node2D
@export var texture_well: Texture2D
@export var texture_workstation: Texture2D
@export var size_well: Vector2 = Vector2(0,0)
@export var size_workstation: Vector2 = Vector2(0,0)
@export var snap_offset: Vector2 = Vector2(0,0)
@onready var interaction_manager: Node2D = get_tree().get_root().get_node("Scene/InteractionManager")
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	#Connect to InteractionManager
	connect("interaction_request", Callable(interaction_manager, "object_interaction"))
	connect("object_hover", Callable(interaction_manager, "interaction_highlight"))
	connect("cleared_hover", Callable(interaction_manager, "clear_highlight"))
	
	# Duplicate shader at start
	add_to_group("draggable")
	if sprite.material:
		sprite.material = sprite.material.duplicate()
	
	#Duplicate shape at start
	collision_shape.shape = collision_shape.shape.duplicate()
	
	var starting_area = get_area_under(global_position)
	if starting_area:
		switch_area(starting_area)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	# Check if mouse button is held on object
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and can_drag:
		if event.is_pressed() and dragged_object == null:
			start_drag()
		else:
			dragging = false
			
func start_drag():
	dragging = true
	original_position = global_position
	offset = global_position - get_global_mouse_position()
	dragged_object = self
	can_snap = false
	saved_snap_point = current_snap_point
	previous_snap_point = current_snap_point
	if previous_snap_point:
		previous_snap_point.set_meta("Occupied", false)
		current_snap_point = null
		detach_origin = previous_snap_point.global_position

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		if dragging:
			dragging = false
			dragged_object = null
			
			var area = get_area_under(global_position)
			if area and area.name != last_area:
				last_area = area.name
				switch_area(area)
				
			var is_snapped = false
			var dist_from_previous = INF
			
			if previous_snap_point:
				dist_from_previous = global_position.distance_to(previous_snap_point.global_position)
				if dist_from_previous > snap_threshold:
					previous_snap_point.set_meta("Occupied", false)
					current_snap_point = null
					can_snap = true
					
			if can_snap:
				for point in snap_points.get_children():
					if point == saved_snap_point:
						continue
					if point.get_meta("Occupied") == false and global_position.distance_to(point.global_position) < snap_threshold:
						is_snapped = true
						current_snap_point = point
						current_snap_point.set_meta("Occupied", true)
						break
					
			if last_area == "Well" and is_snapped == false:
				if saved_snap_point:
					saved_snap_point.set_meta("Occupied", true)
					current_snap_point = saved_snap_point	
					previous_snap_point = saved_snap_point
					detach_origin = saved_snap_point.global_position
					can_snap = false
				global_position = original_position
				var area_check = get_area_under(original_position)
				switch_area(area_check)
				return
				
			if overlapped_object and workstation.is_ancestor_of(overlapped_object) and workstation.is_ancestor_of(self):
				emit_signal("interaction_request", self, overlapped_object)
				overlapped_object = null
	
func _process(_delta):
	
	if dragging and previous_snap_point and can_snap == false:
		if global_position.distance_to(detach_origin) > snap_threshold:
			can_snap = true
			
	# Move object when dragging
	if dragging:
		var mouse_pos = get_global_mouse_position() + offset
		var screen_rect = get_viewport_rect()

		# Clamp the center (global position) of the Area2D to stay within the screen
		mouse_pos.x = clamp(mouse_pos.x, 0, screen_rect.size.x)
		mouse_pos.y = clamp(mouse_pos.y, 0, screen_rect.size.y)
		
		global_position = mouse_pos
		
		#Checks if viewport is switched
		var area = get_area_under(global_position)
		if area and area.name != last_area:
			last_area = area.name
			switch_area(area)
		
		# Snapping logic
		var nearest_dist = snap_threshold
		var nearest_snap = null
		
		if can_snap and snap_points.is_visible_in_tree():
			for point in snap_points.get_children():
				if point == previous_snap_point:
					continue
				elif point.get_meta("Occupied") == false:
					var dist = mouse_pos.distance_to(point.global_position)
					if dist < nearest_dist:
						nearest_snap = point
						nearest_dist = dist
				
			if nearest_snap:
				global_position = nearest_snap.global_position + snap_offset
			elif nearest_snap and mouse_pos.distance_to(nearest_snap.global_position) > snap_threshold:
				nearest_snap = null
			
		# Detect overlapping object
		var space_state = get_world_2d().direct_space_state
		var params = PhysicsShapeQueryParameters2D.new()
		params.shape = collision_shape.shape.duplicate()
		params.transform = Transform2D(0, global_position)
		params.collide_with_areas = true
		params.exclude = [self]
		
		var collisions = space_state.intersect_shape(params, 10)
		var closest_dist = INF
		var closest_object = null
		
		for result in collisions:
			var collider = result.collider
			if collider != null and collider != self and collider.is_in_group("interactable"):
				var dist = collider.global_position.distance_to(global_position)
				if dist < closest_dist:
					closest_dist = dist
					closest_object = collider
		
		overlapped_object = closest_object
		
		if overlapped_object != previous_overlap:
			if previous_overlap:
				emit_signal("cleared_hover", previous_overlap)
			if overlapped_object and workstation.is_ancestor_of(overlapped_object) and workstation.is_ancestor_of(self):
				emit_signal("object_hover", self, overlapped_object)
		
		previous_overlap = overlapped_object

	else:
		if previous_overlap != null:
			emit_signal("cleared_hover", previous_overlap)
		previous_overlap = null
		overlapped_object = null
		
func get_area_under(pos: Vector2) -> Area2D:
	var candidates = [well, workstation, dialogue]
	for area in candidates:
		var area_collision_shape: CollisionShape2D = area.get_node("CollisionShape2D")
		if area_collision_shape.shape is RectangleShape2D:
			var shape: RectangleShape2D = area_collision_shape.shape
			var extents = shape.extents
			var global_pos = area_collision_shape.get_global_position()
			var top_left = global_pos - extents
			var rect = Rect2(top_left, extents * 2)
			if rect.has_point(pos):
				return area
	return null

func switch_area(area: Area2D) -> void:
	var global_pos = global_position
	can_snap = true
	
	# Reparent this object to the new area
	if has_been_initialized:
		Callable(func():
			get_parent().remove_child(self)
			if area == well:
				var visible_section = area.get_node("Sections").get_children().filter(func(s): return s.visible)[0]
				visible_section.get_node("Objects").add_child(self)
			else:
				area.get_node("Objects").add_child(self)
			global_position = global_pos
		).call_deferred()
		
	has_been_initialized = true
	
	#Update object size and appearence
	if area == well or area == dialogue:
		sprite.texture = texture_well
		scale = Vector2(1.0,1.0)
		var area_shape = RectangleShape2D.new()
		area_shape.extents = size_well
		collision_shape.shape = area_shape
	elif area == workstation:
		sprite.texture = texture_workstation
		scale = Vector2(1.5,1.5)
		var area_shape = RectangleShape2D.new()
		area_shape.extents = size_workstation
		collision_shape.shape = area_shape
	
	#Update shader to clip object to new area
	var collision_shape_area = area.get_node("CollisionShape2D")
	var shape = collision_shape_area.shape
	var extents = shape.extents
	var global_origin = collision_shape_area.get_global_position()
	var top_left = global_origin - extents
	var bottom_right = global_origin + extents
	sprite.material.set_shader_parameter("boundary_min", top_left)
	sprite.material.set_shader_parameter("boundary_max", bottom_right)
	
