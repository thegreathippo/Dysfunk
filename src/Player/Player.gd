extends KinematicBody2D

export var move_speed = 12 * global.UNIT_SIZE

var velocity = Vector2()
var gravity
var drag = 1.0

var max_jump_velocity 
var min_jump_velocity 
var max_jump_height = 6.25 * global.UNIT_SIZE
var min_jump_height = 0.75 * global.UNIT_SIZE
var jump_duration = 0.5

var wall_jump_velocity = Vector2(-40 * global.UNIT_SIZE, 0)

var wall_direction = 0


onready var floor_raycasts = $Raycasters/GroundRays
onready var left_wall_raycasts = $Raycasters/WallRays/Left
onready var right_wall_raycasts = $Raycasters/WallRays/Right

onready var body = $Body
onready var anim_player = $Body/AnimatedSprite
onready var weapon_slot = $Body/Weapon

var blasters = [preload("res://src/Weapons/Blaster.tscn").instance(),
			preload("res://src/Weapons/Peashooter.tscn").instance()]

var blaster

var motion_state

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	motion_state = MotionState.new()
	motion_state.set_state(self, MotionState.Idle)
	blaster = blasters.pop_front()
	weapon_slot.add_child(blaster)


func _physics_process(delta):
	motion_state.handle_process(self, delta)
	apply_gravity(delta)
	apply_movement()
	if Input.is_action_pressed("attack"):
		blaster.fire()
	_debug()

func _input(event):
	motion_state.handle_input(self, event)
	if event.is_action_pressed("change_weapon"):
		weapon_slot.remove_child(blaster)
		blasters.push_back(blaster)
		blaster = blasters.pop_front()
		weapon_slot.add_child(blaster)

func apply_gravity(delta):
	velocity.y += (gravity * drag) * delta

func apply_movement():
	velocity = move_and_slide(velocity, global.UP, global.SLOPE_STOP)
	wall_direction = _get_wall_direction()

func jump():
	velocity.y = max_jump_velocity

func release_jump():
	if velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity

func wall_jump():
	var _velocity = wall_jump_velocity
	_velocity.x *= -wall_direction
	velocity = _velocity

func wall_drop():
	velocity.x = (2 * global.UNIT_SIZE) * wall_direction

func move_on_ground():
	var vx = global.get_input_direction().x
	velocity.x = lerp(velocity.x, move_speed * vx, 0.2)
	if vx != 0:
		body.scale.x = vx

func move_in_air():
	var vx = global.get_input_direction().x
	velocity.x = lerp(velocity.x, move_speed * vx, 0.2)
	if vx != 0:
		body.scale.x = vx

func is_grounded() -> bool:
	for raycast in floor_raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func is_on_wall():
	if wall_direction != 0:
		return true
	return false

func _get_wall_direction():
	var out = 0
	var is_near_wall_left = _check_is_valid_wall(left_wall_raycasts)
	var is_near_wall_right = _check_is_valid_wall(right_wall_raycasts)
	
	if is_near_wall_left && is_near_wall_right:
		out = global.get_input_direction().x
	else:
		out= -int(is_near_wall_left) + int(is_near_wall_right)
	return out

func _check_is_valid_wall(wall_raycasts):
	for raycast in wall_raycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _debug():
	var state_name = motion_state._current_state.get_name()
	$Debug/Motion.set_text(state_name)
	
