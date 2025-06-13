extends Node2D

var target_object: Area2D = null
var dragged_object: Area2D = null


func initiate_pour():
	var target_type = target_object.get_meta("Item_Type")
	var dragged_type = dragged_object.get_meta("Item_Type")
	
	if target_type == "Drain" and dragged_type == "Jigger":
		dragged_object.set_meta("Fill_Level",0.0)
		dragged_object.set_meta("Jigger_Contents","")
		
	elif target_type == "Drain" and dragged_type == "Shaker":
		dragged_object.set_meta("Fill_Level",0.0)
		dragged_object.set_meta("Contents",{})
		
	elif target_type == "Drain" and dragged_type == "Glass":
		dragged_object.set_meta("Fill_Level",0.0)
		dragged_object.set_meta("Contents",{})
	
	elif target_type == "Shaker" and dragged_type == "Scooper":
		target_object.set_meta("Has_Ice", true)
		
	elif target_type == "Glass" and dragged_type == "Scooper":
		target_object.set_meta("Has_Ice", true)
		
	elif target_type == "Shaker" and dragged_type == "Jigger":
		var fill_level: float = dragged_object.get_meta("Fill_Level")
		var ingredient: String = dragged_object.get_meta("Jigger_Contents")
		var contents: Dictionary = target_object.get_meta("Contents")
		
		if ingredient != "":
			if contents.has(ingredient):
				contents[ingredient] += fill_level
			else:
				contents[ingredient] = fill_level
			target_object.set_meta("Contents", contents)

		dragged_object.set_meta("Fill_Level",0.0)
		dragged_object.set_meta("Jigger_Contents","")
		print(contents)
		
	elif target_type == "Glass" and dragged_type == "Shaker":
		var contents: Dictionary = dragged_object.get_meta("Contents")
		var fill_level: float = dragged_object.get_meta("Fill_Level")

		target_object.set_meta("Contents", contents.duplicate())
		target_object.set_meta("Fill_Level", fill_level)

		dragged_object.set_meta("Contents", {})
		dragged_object.set_meta("Fill_Level", 0.0)
		print('test')
