extends Node2D

var web_link_scene := preload("res://scenes/web_link.tscn")
var indicator := preload("res://scenes/indicator.tscn")

## game fps
@export var GAME_FPS: float = 60.0
@onready var player = $Player

var delta_counter := 0.0

func _ready() -> void:
	print('hello')

func _process(delta: float) -> void:
	fps_limited_process(delta)

	if player.player_travel >= WebLink.LINK_LENGTH:
		player.reset_player_travel()
		create_link1()
		var loopGroup = get_tree().get_nodes_in_group("loop")
		print(loopGroup)

func fps_limited_process(delta: float) -> void:
	delta_counter += delta
	if delta_counter >= 1.0 / GAME_FPS:
		delta_counter = 0.0
		
		## do stuff below
	
#func track_player_travel():
	#if Input.is_action_pressed("create_web"):
		#if player_last_position == null:
			#player_last_position = player.global_position
		#else:
			#player_travel += player.global_position.distance_to(player_last_position)
			#player_last_position = player.global_position
	#else:
		#player_travel = 0.0
		#player_last_position = null

func create_link1():
	var new_link = web_link_scene.instantiate()
	var link_collision_shape := new_link.get_node("CollisionShape2D") as CollisionShape2D
	var link_length = link_collision_shape.shape.size.x as float
	
	var movement_vector = $Player.velocity.normalized()
	var player_position = $Player.position
	
	new_link.position = player_position.move_toward(player_position + movement_vector, -link_length)
	new_link.rotation = movement_vector.angle()
	
	add_child(new_link)
	new_link.add_to_group("loop")
	
func create_link():
	var new_link1 = web_link_scene.instantiate()
	var new_link2 = web_link_scene.instantiate()
	var joint = PinJoint2D.new()
			
	var movement_vector = $Player.velocity.normalized()
	var player_position = $Player.position
			
	new_link1.position = player_position.move_toward(player_position + movement_vector, -40.0)
	new_link1.rotation = movement_vector.angle()
	new_link2.position = player_position.move_toward(player_position + movement_vector, -20.0)
	new_link2.rotation = movement_vector.angle()
	add_child(new_link1)
	add_child(new_link2)
	print('link1 name', new_link1.name)
	print('link2 name', new_link2.name)
			
	joint.position = player_position.move_toward(player_position + movement_vector, -30.0)
	#joint.rotation = movement_vector.angle()
	#new_link1.get_path()
	joint.node_a = new_link1.get_path()
	joint.node_b = new_link2.get_path()
	
	add_child(joint)
	print('uh')

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
