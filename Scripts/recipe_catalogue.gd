extends Node2D

var recipes = {
	"Whiskey Neat": {
		"ingredients": {"whiskey": 2},
		"prep": "built",
		"glass": "rocks",
		"ice": false,
		"soda": false
	},

	"Whiskey on the Rocks": {
		"ingredients": {"whiskey": 2},
		"prep": "built",
		"glass": "rocks",
		"ice": true,
		"soda": false
	},
	
	"Vodka Highball": {
		"ingredients": {"vodka": 2},
		"prep": "built",
		"glass": "highball",
		"ice": true,
		"soda": true
	},
	
	"Daiquiri": {
		"ingredients": {"rum": 2, "lime": 1, "syrup": 0.5},
		"prep": "shaken",
		"glass": "rocks",
		"ice": true,
		"soda": false
	}
}
