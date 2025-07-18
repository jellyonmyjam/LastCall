extends Sprite2D

# Liquid fill levels: 0, 2, 4, 6, 8
@export var liquid_textures: Array[Texture2D] = [
	preload("res://Sprites/Glasses/Rocks Liquid/Liquid 1.png"), # corresponds to 0
	preload("res://Sprites/Glasses/Rocks Liquid/Liquid 2.png"), # corresponds to 2
	preload("res://Sprites/Glasses/Rocks Liquid/Liquid 3.png"), # corresponds to 4
	preload("res://Sprites/Glasses/Rocks Liquid/Liquid 4.png"), # corresponds to 6
	preload("res://Sprites/Glasses/Rocks Liquid/Liquid 5.png")  # corresponds to 8
]

var _current_fill = 0.0
var _last_fill_index = -1

# This property lets you externally assign to current_fill and updates the texture when the rounded value changes
var current_fill: float:
	set(value):
		_current_fill = value
		_update_texture()
	get:
		return _current_fill

func _update_texture():
	var rounded_fill = clamp(round(_current_fill / 2.0) * 2, 0, 8)
	var texture_index = int(rounded_fill / 2)
	if texture_index != _last_fill_index and texture_index < liquid_textures.size():
		texture = liquid_textures[texture_index]
		_last_fill_index = texture_index
