extends Node2D

var web_link_scene := preload("res://scenes/web_link.tscn")
var indicator := preload("res://scenes/indicator.tscn")

## game fps
@export var GAME_FPS: float = 60.0
@onready var player = $Player


var delta_counter := 0.0

var loops: Dictionary[int, WebLoop] = {}

func _ready() -> void:
	player.create_web_link.connect(_create_web_link)

func _create_web_link(id: int):
	# var loop = WebLoop.new(self)
	if loops.has(id):
		loops[id].create_link()
	else:
		var new_loop = WebLoop.new(self)
		loops[id] = new_loop

func _process(delta: float) -> void:
	# print('loops', loops)
	fps_limited_process(delta)

func fps_limited_process(delta: float) -> void:
	delta_counter += delta
	if delta_counter >= 1.0 / GAME_FPS:
		delta_counter = 0.0
		
		## do stuff below

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
