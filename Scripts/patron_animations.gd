extends Sprite2D

@export var amplitude: float = 3.0       # How far it moves up and down
@export var speed: float = 1.5          # How fast it moves
var base_y: float
var is_animated = false

func _ready():
	base_y = position.y

func _process(_delta):
	if is_animated == false:
		position.y = base_y + sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude
	else:
		position.y = base_y + sin(Time.get_ticks_msec() / 1000.0 * 8.0) * 6.0
	
func arrive():
	is_animated = true
	var original_position = position
	global_position.x = -200  # Start offscreen to the left (adjust if needed)

	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", original_position.x, 3.0).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	
	is_animated = false
	await get_tree().create_timer(1.0).timeout
	
	
func exit():
	is_animated = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", -500, 3.0).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	
