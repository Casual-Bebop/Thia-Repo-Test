extends Node

@export var max_blink_distance = 20.0
@onready var raycast = $"../PlayerCamera/RayCast3D"
@onready var blink_icon = $"../BlinkIconMesh"
@onready var player = get_parent() as CharacterBody3D

var blink_position = Vector3()

func _ready():
	raycast.enabled = false
	blink_icon.visible = false
	
func _process(_delta):
	if Input.is_action_pressed("Ability"):
		show_blink_icon()
	elif Input.is_action_just_released("Ability"):
		blink()

func show_blink_icon():
	raycast.enabled = true
	raycast.force_raycast_update()
	if raycast.is_colliding():
		blink_position = raycast.get_collision_point()		
		blink_icon.global_transform.origin = blink_position
		blink_icon.visible = true
	
	else:
		blink_icon.visible = false
	
func blink():
	if blink_icon.visible:
		#player.global_transform.origin = blink_position
		var vertical_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		vertical_tween.tween_property(player, "global_transform:origin", blink_position, 0.2)
		blink_icon.visible = false
	raycast.enabled = false

#!!! Below is what I can do to check if an upwards raycast detects a collision & adjust the position of the player so they don't spawn ontop of something they shouldn't
#Need to make sure ray's origin is below the origin of blinkIcon, because it intersects objects & the ray wont detect a collision.
#!!! Problem is it registers the ground & spawns the player underneath objects. Need to think of a way to make sure this doesnt happen whilst keeping the ceiling logic in
#Easiest to code way would be to have a scene called blink object top, change the icon like in Dishonoured and have a climb animation if the player targets it, else, instantiate them away?
#if not ray_UP.get_collider().is_in_group("Ground"):
	#blink_position = ray_UP.get_collision_point()
#!!! Suggest using groups to detect. Could also use ceiling/floor colliders / nodes and line them up in a scene.
#@onready var ray_UP = $"../BlinkIconMesh/RayUp"
	#ray_UP.enabled = true
	#ray_UP.force_raycast_update()
	#if ray_UP.is_colliding():
		#blink_position.y -= 2.0
