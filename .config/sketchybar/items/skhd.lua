local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local skhd = sbar.add("item", {
	background = {
		color = colors.transparent
	},
	icon = { 
		string = "[N]",
		colors = colors.blue,
		padding_left = 10,
		padding_right = 5
	}
})



