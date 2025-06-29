extends Sprite2D

@export var amplitude: float = 3.0       # How far it moves up and down
@export var speed: float = 1.5          # How fast it moves
var base_y: float

func _ready():
	base_y = position.y

func _process(_delta):
	position.y = base_y + sin(Time.get_ticks_msec() / 1000.0 * speed) * amplitude
