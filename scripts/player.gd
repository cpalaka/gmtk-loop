class_name Player
extends CharacterBody2D

## max player speed
@export var SPEED_MAX: float = 700.0
## time to ease in to max speed in seconds
@export var max_click_hold: float = 1.0
## time to ease in to max speed in seconds
# @export var max_rot_time: float = 1.0

@onready var PLAYER_LENGTH = $CollisionShape2D.shape.height

@onready var mouse_vec := get_global_mouse_position()
#can just use position here
@onready var player_vec := Vector2(position.x, position.y)

var current_web_id = 0

signal create_web_link(id: int)

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

# var rot_time := 0.0

func _process(delta: float) -> void:
	# print(position, global_position)
	# print(velocity)
	track_move_time(delta)
	track_player_travel()

	# rotate player sprite to mouse
	# todo: add easing
	mouse_vec = get_global_mouse_position()
	player_vec = Vector2(position.x, position.y)
	# rotation = player_vec.angle_to_point(mouse_vec) - deg_to_rad(270)

@onready var prev_dir_vector: Vector2 = velocity.normalized()
var dir_change_time: float = 0.0

func _physics_process(delta: float) -> void:
	#normalized_speed = smoothstep(0.0, max_click_hold, click_time) # simple smoothstep
	var normalized_speed = lerpf(0, max_click_hold, ease(click_time, 3.4)) # lerped

	var direction_vector = player_vec.direction_to(mouse_vec)

	# TODO: fix direction vector easing
	if direction_vector.normalized() != prev_dir_vector:
		dir_change_time += delta * 0.1
		if dir_change_time >= 1.0:
			dir_change_time = 1.0
	else:
		dir_change_time = 0.0
	
	var eased_direction_vector = velocity.normalized().lerp(direction_vector, dir_change_time)

	velocity = eased_direction_vector * normalized_speed * SPEED_MAX
	rotation = eased_direction_vector.angle() - deg_to_rad(270)

	prev_dir_vector = velocity.normalized()

	# move player
	var collision = move_and_collide(velocity * delta)
	
	# collision logic with weblinks
	# TODO: fix
	if collision:
		var collider = collision.get_collider() as WebLink
		if collider:
			collider.apply_impulse(velocity/SPEED_MAX, collision.get_position())

var player_travel := 0.0
var player_last_position = null

func track_player_travel():
	if Input.is_action_pressed("create_web"):
		if player_last_position == null:
			player_last_position = global_position
		else:
			player_travel += global_position.distance_to(player_last_position)
			player_last_position = global_position
		
		if player_travel >= WebLink.LINK_LENGTH:
			reset_player_travel()
			create_web_link.emit(current_web_id)

	if Input.is_action_just_released("create_web"):
		player_travel = 0.0
		player_last_position = null
		current_web_id += 1

func reset_player_travel():
	player_travel = 0.0

var click_time := 0.0 # up to max of max_click_hold

func track_move_time(delta: float) -> void:
	#slow down when close to
	var distance_between := mouse_vec.distance_to(player_vec)
	if distance_between < PLAYER_LENGTH / 2:
		if click_time >= 0:
			click_time -= 5 * delta
			if click_time <= 0.0:
				click_time = 0.0

	if Input.is_action_pressed("move_player"):
		click_time += delta
		if click_time >= max_click_hold:
			click_time = max_click_hold
	else:
		#TODO: add separate release time to configure slowdown friction
		#independent of click hold
		if click_time >= 0:
			click_time -= delta
			if click_time <= 0.0:
				click_time = 0.0
