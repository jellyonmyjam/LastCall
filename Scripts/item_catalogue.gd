extends Node2D

var bottle_data = {
	"Spudmash": {
		"type": "Vodka",
		"volume": 25.0,
		"description": "Distilled from surplus root vegetables and desalinated runoff. Slightly alkaline finish.",
		"texture_well": load("res://Sprites/Bottles/VodkaSide.png"),
		"texture_workstation": load("res://Sprites/Bottles/VodkaTop.png"),
		"color": Color ("#FFFFFF99")
	},
	"Knotroot Reserve": {
		"type": "Whiskey",
		"volume": 25.0,
		"description": "Grain-neutral base enhanced with synthesized oak profile. Standard issue for long-haul personnel.",
		"texture_well": load("res://Sprites/Bottles/WhiskeySide.png"),
		"texture_workstation": load("res://Sprites/Bottles/WhiskeyTop.png"),
		"color": Color ("#C47A3F99")
	},
	"Mollassex Dark": {
		"type": "Rum",
		"volume": 25.0,
		"description": "Heavy-bodied ethanol blend with industrial sweetener compound. Stored in polymer drums prior to bottling.",
		"texture_well": load("res://Sprites/Bottles/RumSide.png"),
		"texture_workstation": load("res://Sprites/Bottles/RumTop.png"),
		"color": Color ("#5C2E0F99")
	},
	"Tang-O Deluxe": {
		"type": "Lime",
		"volume": 10.0,
		"description": "Rehydrated flavor concentrate with color stabilizers. Common in institutional rations",
		"texture_well": load("res://Sprites/Bottles/LimeSide.png"),
		"texture_workstation": load("res://Sprites/Bottles/LimeTop.png"),
		"color": Color ("#D4F07499")
	},
	"Pitfruit Synth": {
		"type": "Brandy",
		"volume": 25.0,
		"description": "Fermented composite of orchard byproduct and neutral grain spirit. Popular among older miners.",
		"texture_well": load("res://Sprites/Bottles/BrandySide.png"),
		"texture_workstation": load("res://Sprites/Bottles/BrandyTop.png"),
		"color": Color ("#A1532599")
	},
	"Aro-Agent Red": {
		"type": "Vermouth",
		"volume": 25.0,
		"description": "Botanical extract diluted in stabilizing agent. Marketed as both mixer and palate suppressant.",
		"texture_well": load("res://Sprites/Bottles/VermouthSide.png"),
		"texture_workstation": load("res://Sprites/Bottles/VermouthTop.png"),
		"color": Color ("#73151599")
	},
	"Glucodex": {
		"type": "Syrup",
		"volume": 10.0,
		"description": "Thickened sugar analog with long shelf life. Remains viscous at sub-zero temperatures.",
		"texture_well": load("res://Sprites/Bottles/SyrupSide.png"),
		"texture_workstation": load("res://Sprites/Bottles/SyrupTop.png"),
		"color": Color ("#EDEDED99")
	},
	"Vat Swill": {
		"type": "Ethanol",
		"volume": 25.0,
		"description": "Unlabeled ethanol product with basic filtration. Typically consumed under duress.",
		"texture_well": load("res://Sprites/Bottles/SwillSide.png"),
		"texture_workstation":  load("res://Sprites/Bottles/SwillTop.png"),
		"color": Color ("#F8F8F899")
	}
}


var glass_data = {
	"Rocks": {
		"type": "Rocks",
		"texture_well": load("res://Sprites/Glasses/RocksSide.png"),
		"texture_workstation": load("res://Sprites/Glasses/RocksTop.png"),
		"texture_liquid": load("res://Sprites/Glasses/RocksLiquid.png"),
		"minigame_offset": 40,
		"liquid_offset": Vector2 (-3,-10)
	},
	"Highball": {
		"type": "Highball",
		"texture_well":  load("res://Sprites/Glasses/HighballSide.png"),
		"texture_workstation":  load("res://Sprites/Glasses/HighballTop.png"),
		"texture_liquid": load("res://Sprites/Glasses/HighballLiquid.png"),
		"minigame_offset": 0,
		"liquid_offset": Vector2 (0,0)
	},
	"Coupe": {
		"type": "Coupe",
		"texture_well":  load("res://Sprites/Glasses/CoupeSide.png"),
		"texture_workstation":  load("res://Sprites/Glasses/CoupeTop.png"),
		"texture_liquid": load("res://Sprites/Glasses/CoupeLiquid.png"),
		"minigame_offset": 0,
		"liquid_offset": Vector2 (0,-70)
	},
	"Mug": {
		"type": "Mug",
		"texture_well": load("res://Sprites/Glasses/MugSide.png"),
		"texture_workstation":  load("res://Sprites/Glasses/MugTop.png"),
		"texture_liquid": load("res://Sprites/Glasses/MugLiquid.png"),
		"minigame_offset": 0,
		"liquid_offset": Vector2 (0,40)
	},
}
