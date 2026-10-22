extends Node

const TILE_SIZE = 16
const PLAYER_TILE_SIZE = 2
var auto_level_prog: bool = false

var selected_level: PackedScene = preload("res://scenes/level_01.tscn")
