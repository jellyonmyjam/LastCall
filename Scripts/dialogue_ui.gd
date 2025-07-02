extends Control

const speech_bubble = preload("res://Scenes/UI/speechbubble.tscn")
var speech_bubbles = []
var is_shifting_bubbles = false

func _ready():
	create_text(true,"What can I get you?")
	await get_tree().create_timer(2.0).timeout
	create_text(false,"Pour me a whiskey.")
	await get_tree().create_timer(2.0).timeout
	create_text(true,"Coming right up.")
	
func create_text(player,dialogue):
	var panel = speech_bubble.instantiate()
	panel.modulate.a = 0.0
	add_child(panel)
	var label: Label = panel.get_node("MarginContainer/Label")
	label.text = dialogue
	if player:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	var max_width := 400
	var min_width := 100
	var increment := 5

	label.custom_minimum_size.x = max_width
	panel.custom_minimum_size.x = max_width
	await get_tree().process_frame
	var line_count = label.get_line_count()

	while label.get_line_count() == line_count and max_width > min_width:
		max_width -= increment
		label.custom_minimum_size.x = max_width
		panel.custom_minimum_size.x = max_width
		await get_tree().process_frame
	
	max_width += increment
	label.custom_minimum_size.x = max_width
	panel.custom_minimum_size.x = max_width
	await get_tree().process_frame
	
	while is_shifting_bubbles:
		await get_tree().process_frame
		
	if speech_bubbles.is_empty():
		panel.position = Vector2(0,0)
	else:
		var bottom_panel = speech_bubbles[-1]
		panel.position = Vector2(0, bottom_panel.position.y + bottom_panel.size.y + 10)
	
	speech_bubbles.append(panel)
	
	if player:
		panel.position = Vector2(600 - panel.size.x, panel.position.y)

	var tween := create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
#
	# Wait before fading out
	await get_tree().create_timer(6.0).timeout
	
	shift_bubbles(panel.size.y, panel)
	
	# Fade out
	var fade_out = create_tween()
	fade_out.tween_property(panel, "modulate:a", 0.0, 0.3)
	await fade_out.finished
	
	speech_bubbles.erase(panel)
	panel.queue_free()


func shift_bubbles(shift_amount, skip_panel):
	is_shifting_bubbles = true
	var tweens = []
	for bubble in speech_bubbles:
		if bubble != skip_panel and bubble.position.y > skip_panel.position.y:
			var t = create_tween()
			t.tween_property(bubble, "position:y", bubble.position.y - shift_amount, 0.3)
			tweens.append(t)
	for t in tweens:
		await t.finished
	is_shifting_bubbles = false
