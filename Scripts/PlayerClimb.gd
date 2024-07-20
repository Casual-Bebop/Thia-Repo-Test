extends Node

@onready var player = get_parent() as CharacterBody3D
@onready var chest_ray = $"../ChestRay"
@onready var head_ray = $"../HeadRay"

@onready var ledge_ray_forward = $"../LedgeRayForward"
@onready var ledge_ray_Down = $"../Node3D/LedgeRayDown"
@onready var ledge_holder = $"../Node3D"
@onready var ledge_marker = $"../Node3D/LedgeRayDown/MeshInstance3D"

var hit2

var is_climbing = false

func can_climb():
	if chest_ray.is_colliding() and !head_ray.is_colliding():
		return true
	return false
	
func grab_ledge():
	player.velocity = Vector3.ZERO
	climb_ledge()
	
func climb_ledge():
	if is_climbing:
		return
	is_climbing = true
	climb()
	
func _process(_delta):
	var hit1 = ledge_ray_forward.get_collision_point()
	var offset = Vector3(0, 2, 0)
	
	if ledge_ray_forward.is_colliding():
		#ledge_ray_forward.force_raycast_update()
		ledge_holder.global_transform.origin = hit1 + offset
		ledge_ray_Down.force_raycast_update()
		hit2 = ledge_ray_Down.get_collision_point()
		ledge_marker.global_transform.origin = hit2
		ledge_marker.visible = true
		ledge_ray_Down.enabled = true
	else:
		ledge_marker.visible = false
		ledge_ray_Down.enabled = false
	
func climb():
	#var collision_point = chest_ray.get_collision_point()
	#var climable_object = chest_ray.get_collider()
	#var climb_destination = climable_object.get_node("ClimbPoint")
	
	#var hit1 = chest_ray.get_collision_point()
	#var offset = Vector3(0, 3, 0)
	#ledge_ray.global_transform.origin = hit1 + offset
	#ledge_ray.force_raycast_update()
	
	#var climb_destination = ledge_ray.get_collision_point()
	#if climb_destination:
		#var destination_y = climb_destination.global_transform.origin.y
		#var destination = Vector3(collision_point.x, destination_y, collision_point.z)
		#climb_animation(destination)
		climb_animation(hit2)
	#else:
	#	is_climbing = false
	
func climb_animation(destination):
	var vertical_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	vertical_tween.tween_property(player, "global_transform:origin", destination, 0.4) #USE self instead of player if using the object this is attached too.
	
	# We wait for the animation to finish.
	await vertical_tween.finished
	
	# Second Tween animation will make the player move forward where the player is facing.
	#var forward = player.global_transform.origin + (-player.basis.z * 0.5)
	#var forward_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	#forward_tween.tween_property(player, "global_transform:origin", forward, 0.3)
	
	# We wait for the animation to finish.
	#await forward_tween.finished
	
	# Player isn't climbing anymore.
	is_climbing = false
