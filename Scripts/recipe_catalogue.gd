extends Node2D

var recipes = {
	"Whiskey Neat": {
		"ingredients": {"Whiskey": 2},
		"prep": "Built",
		"glass": "Rocks",
		"ice": false,
		"soda": false
	},

	"Whiskey on the Rocks": {
		"ingredients": {"Whiskey": 2},
		"prep": "Built",
		"glass": "Rocks",
		"ice": true,
		"soda": false
	},
	
	"Vodka Fizz": {
		"ingredients": {"Vodka": 2},
		"prep": "Built",
		"glass": "Highball",
		"ice": true,
		"soda": true
	},
	
	"Daiquiri": {
		"ingredients": {"Rum": 2, "Lime": 1, "Syrup": 0.5},
		"prep": "Shaken",
		"glass": "Rocks",
		"ice": true,
		"soda": false
	}
}
