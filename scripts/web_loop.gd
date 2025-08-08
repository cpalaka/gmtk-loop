class_name WebLoop
extends RefCounted

var web_link_scene := preload("res://scenes/web_link.tscn")

#TODO: consider PackedVector2Arrays instead
var link_group: Array[WebLink] = []
var joint_group: Array[PinJoint2D] = []
var parentNode: Node2D
var player: Player

func _init(node: Node2D):
	parentNode = node
	player = node.get_node("Player")

func create_link():
	var movement_vector = player.velocity
	var player_position = player.position

	var new_link = web_link_scene.instantiate()

	var link_collision_shape = new_link.get_node("CollisionShape2D") as CollisionShape2D
	var link_length = link_collision_shape.shape.size.x as float

	var player_shape = player.get_node("CollisionShape2D") as CollisionShape2D
	var player_height = player_shape.shape.height

	var new_link_distance = (player_height + link_length) / 2;
	
	if link_group.size() > 0:
		#todo: position new link according to previous link
		var prev_link = link_group.back()
		
		var prev_link_end = prev_link.position.move_toward(player_position, link_length/2)
		new_link.position = prev_link_end.move_toward(player_position, link_length/2)
		new_link.look_at(player.position)
		# new_link.rotate(PI)
	else:
		new_link.position = player_position.move_toward(player_position + movement_vector, -new_link_distance)
		new_link.rotation = movement_vector.angle()
	# new_link.position = player_position.move_toward(player_position + movement_vector, -new_link_distance)
	# new_link.rotation = movement_vector.angle()

	#tune this
	new_link.linear_damp = 1.0
	
	parentNode.add_child(new_link)

	if link_group.size() > 0:
		var new_joint = PinJoint2D.new()
		new_joint.bias = 1.0
		new_joint.softness = 10.0
		new_joint.disable_collision = false
		
		var prev_link = link_group.back()
		#position joint at the intersection of the 2 links, whatever their orientation
		#TODO: fix this w better vector math
		var prev_link_end = prev_link.position.move_toward(player_position, link_length/2)
		new_joint.position = prev_link_end

		new_joint.node_a = prev_link.get_path()
		new_joint.node_b = new_link.get_path()

		parentNode.add_child(new_joint)
		joint_group.append(new_joint)
		new_joint.add_to_group("joint")

	link_group.append(new_link)
	new_link.add_to_group("loop")
