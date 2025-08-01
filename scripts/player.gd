extends CharacterBody2D

## max player speed
@export var SPEED_MAX: float = 200.0
## time to ease in to max speed in seconds
@export var max_click_hold: float = 1.0
## time to ease in to max speed in seconds
@export var max_rot_time: float = 1.0

@onready var PLAYER_LENGTH = $CollisionShape2D.shape.height

@onready var mouse_vec := get_global_mouse_position()
@onready var player_vec := Vector2(position.x, position.y)

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

var prev_rotation := rotation

func _process(delta: float) -> void:
	track_move_time(delta)
	track_player_travel()
	# rotate player sprite to mouse
	# todo: add easing
	mouse_vec = get_global_mouse_position()
	player_vec = Vector2(position.x, position.y)
	#var distance_between := mouse_vec.distance_to(player_vec)
	#var from_rotation = rotation
	var to_rotation = player_vec.angle_to_point(mouse_vec)
	rotation = player_vec.angle_to_point(mouse_vec) - deg_to_rad(270)
	#if to_rotation != prev_rotation:
		#rot_time = 0.0
	#
	#if to_rotation != rotation:
		#rot_time += delta
		#if rot_time >= max_rot_time:
			#rot_time = max_rot_time
	#else:
		##rot_time = 0.0
		#if rot_time >= 0:
			#rot_time -= delta
			#if rot_time <= 0.0:
				#rot_time = 0.0
				#
	#rotation = lerp_angle(rotation, to_rotation, ease(rot_time, 3.4))
	#prev_rotation = rotation
	# - deg_to_rad(270)
	#rotation = smoothstep(from_rotation, to_rotation, click_time)

func _physics_process(delta: float) -> void:
	var distance_between := mouse_vec.distance_to(player_vec)
	if distance_between < PLAYER_LENGTH/2:
		click_time = 0.0
	
	#normalized_speed = smoothstep(0.0, max_click_hold, click_time) # simple smoothstep
	normalized_speed = lerpf(0, max_click_hold, ease(click_time, 3.4)) # lerped
	velocity = player_vec.direction_to(mouse_vec) * normalized_speed * SPEED_MAX
	
	# move player
	var collision = move_and_collide(velocity * delta)
	
	# collision logic with weblinks
	# TODO: fix
	if collision:
		var collider = collision.get_collider() as WebLink
		if collider:
			var collision_position = collision.get_position()
			collider.apply_impulse(velocity * delta * 0.01, collision_position)

var player_travel := 0.0
var player_last_position = null

func track_player_travel():
	if Input.is_action_pressed("create_web"):
		if player_last_position == null:
			player_last_position = global_position
		else:
			player_travel += global_position.distance_to(player_last_position)
			player_last_position = global_position
	else:
		player_travel = 0.0
		player_last_position = null

func reset_player_travel():
	player_travel = 0.0

var click_time := 0.0 # up to max of max_click_hold
var rot_time := 0.0
var normalized_speed := 0.0

func track_move_time(delta: float) -> void:
	if Input.is_action_pressed("move_player"):
		click_time += delta
		if click_time >= max_click_hold:
			click_time = max_click_hold
	else:
		if click_time >= 0:
			click_time -= delta
			if click_time <= 0.0:
				click_time = 0.0
