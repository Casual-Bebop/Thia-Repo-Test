extends CharacterBody3D

var forward_speed = 3.5
var strafe_speed = 3
var back_speed = 2.5

var run_multiplier: float = 2
var SPEED = 3.5

var move_dir: Vector2
var look_dir: Vector2

#player states
var is_running: bool = false
var is_jumping: bool = false

const JUMP_VELOCITY = 4.5
const SENSITIVITY = 2
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camPivot = $CameraPivot
@onready var camera = $PlayerCamera

@onready var player_blink = $PlayerBlink
@onready var player_climb = $PlayerClimb

var move_buffer: bool = false
var move_buffer_timer: float = 0.1

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		rotation.y -= look_dir.x * SENSITIVITY
		camera.rotation.x = clamp(camera.rotation.x - look_dir.y * SENSITIVITY, -1.4, 1.4)
		
	if Input.is_action_just_pressed("sprint"):
		is_running = !is_running
		
	if Input.is_action_just_pressed("Esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

#Different speeds for forward, strafe & back
func _dirSpeed(delta) -> float:
	if Input.is_action_pressed("forward"):
		SPEED = forward_speed
	elif Input.is_action_pressed("back"):
		SPEED = back_speed
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		SPEED = strafe_speed
	return SPEED

# multiply the directional speed by a number to create a sprint
func _run(delta) -> float:
	if is_running == true:
		run_multiplier = 2
	else:
		run_multiplier = 1
	return run_multiplier

func _physics_process(delta):
	print(SPEED)
	player_blink._process(delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta

# JUMP
	if Input.is_action_just_pressed("jump"):
		if player_climb.can_climb() and !player_climb.head_ray.is_colliding(): 
			player_climb.grab_ledge()
			
		elif is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		elif not is_on_floor() and player_climb.can_climb():
			player_climb.grab_ledge()

# MOVE
	move_dir = Input.get_vector("left", "right", 'forward', "back")
	var direction = (camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * (_dirSpeed(delta) * _run(delta))
			velocity.z = direction.z * (_dirSpeed(delta) * _run(delta))
		else:
			velocity.x = lerp(velocity.x, direction.x * (_dirSpeed(delta) * _run(delta)), delta * 16)
			velocity.z = lerp(velocity.z, direction.z * (_dirSpeed(delta) * _run(delta)), delta * 16)
			if velocity.x >= -0.05 and velocity.x <= 0.05:
				velocity.x = 0
				is_running = false
			if velocity.z >= -0.05 and velocity.z <= 0.05:
				velocity.z = 0
				is_running = false
	else:
		velocity.x = lerp(velocity.x, direction.x * (_dirSpeed(delta) * _run(delta)), delta * 2)
		velocity.z = lerp(velocity.z, direction.z * (_dirSpeed(delta) * _run(delta)), delta * 2)
	move_and_slide()
