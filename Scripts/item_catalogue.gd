extends Node2D

var bottle_data = {
	"Spudmash": {
		"type": "vodka",
		"volume": 25.0,
		"description": "Triple-filtered through recycled hydroponics mats. Still carries a faint whiff of starch and floor cleaner.",
		"texture_well": load("res://Sprites/Bottles/VodkaSide.png"),
		"texture_workstation": load("res://Sprites/Bottles/VodkaTop.png")
	},
	"Knotwood Reserve": {
		"type": "whiskey",
		"volume": 25.0,
		"description": "Distilled from faux-grain mash and aged in synthetic wood barrels. Smooth but unmemorable.",
		"texture_well":  load("res://Sprites/Bottles/WhiskeySide.png"),
		"texture_workstation":  load("res://Sprites/Bottles/WhiskeyTop.png")
	},
	"Molassic": {
		"type": "rum",
		"volume": 25.0,
		"description": "Thick, sweet, and vaguely combustible. The favorite of night shifters.",
		"texture_well":  load("res://Sprites/Bottles/RumSide.png"),
		"texture_workstation":  load("res://Sprites/Bottles/RumTop.png")
	},
	"Agent Green": {
		"type": "lime",
		"volume": 10.0,
		"description": "Infused with stabilized herb compounds and a touch of bitterness, legal and otherwise.",
		"texture_well": load("res://Sprites/Bottles/BittersSide.png"),
		"texture_workstation":  load("res://Sprites/Bottles/BittersTop.png")
	},
}


var glass_data = {
	"Rocks": {
		"type": "rocks",
		"texture_well": load("res://Sprites/Glasses/RocksSide.png"),
		"texture_workstation": load("res://Sprites/Glasses/RocksTop.png")
	},
	"Highball": {
		"type": "highball",
		"texture_well":  load("res://Sprites/Glasses/HighballSide.png"),
		"texture_workstation":  load("res://Sprites/Glasses/HighballTop.png")
	},
	"Coupe": {
		"type": "coupe",
		"texture_well":  load("res://Sprites/Glasses/CoupeSide.png"),
		"texture_workstation":  load("res://Sprites/Glasses/CoupeTop.png")
	},
	"Mug": {
		"type": "mug",
		"texture_well": load("res://Sprites/Glasses/MugSide.png"),
		"texture_workstation":  load("res://Sprites/Glasses/MugTop.png")
	},
}
