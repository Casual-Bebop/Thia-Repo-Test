extends Node3D

@export var plinths: Array[MeshInstance3D] = []
@export var colorSequence: Array[Color] = []
@export var prefabLocations: Array[Node3D] = []
var acMeshPrefab = preload("res://Scenes/ac_mesh_prefab.tscn")

@onready var acHub = $CSGMesh3D2

@onready var player = $"../Player" as CharacterBody3D
@onready var player_camera = $"../Player" as Camera3D
@onready var solve_point = $SolvePoint
@onready var look_point = $LookPoint

func update_meshPrefabs(p: MeshInstance3D, color: Color):
	print("Running update_meshPrefabs")
	
	for i in range(plinths.size()):
		if p == plinths[i]:
			print("You have clicked plinth number ", i)
			if prefabLocations[i].get_child_count() == 0:
				var instance = acMeshPrefab.instantiate()
				instance.material_override = StandardMaterial3D.new()
				instance.material_override.albedo_color = color
				prefabLocations[i].add_child(instance)
			else:
				print("A Cube already exists here")
				var j = prefabLocations[i].get_child(0)
				j.material_override = StandardMaterial3D.new()
				j.material_override.albedo_color = color
	
	verify_puzzle()

func verify_puzzle():
	var puzzle_complete = true
	for i in range(plinths.size()):
		var p = plinths[i]
		if (p.material_override):
			var a = p.material_override.albedo_color
			var b = colorSequence[i]
			if a != b:
				puzzle_complete = false
		else:
			puzzle_complete = false
	if puzzle_complete:
		print("Puzzle Completed!!")

func _on_interaction_interacted():
	if player_camera:
		print(name, " Has begun puzzle interaction")
		#player.global_transform = solve_point.global_transform
		start_tween()
	else:
		print("Player null")

func start_tween():
	var target_position = solve_point.global_transform.origin
	var target_rotation = look_point.rotation
	
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(player, "global_transform:origin", target_position, 1)
	
	var end_rotation = target_rotation.y
	var rotate_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	rotate_tween.tween_property(player, "rotation:y", end_rotation, 1)
	
	var camera_end_rotation = target_rotation.x
	var cam_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	cam_tween.tween_property(player_camera, "rotation:x", camera_end_rotation, 1)
