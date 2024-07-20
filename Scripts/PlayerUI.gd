extends Control

@export var curPlinth: MeshInstance3D = null;
@export var abstract_composition: Node3D

func _on_red_pressed():	
	curPlinth.material_override = StandardMaterial3D.new()
	curPlinth.material_override.albedo_color = Color(1, 0, 0)
	abstract_composition.update_meshPrefabs(curPlinth, Color(1, 0, 0))
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_visible(false)


func _on_yellow_pressed():
	curPlinth.material_override = StandardMaterial3D.new()
	curPlinth.material_override.albedo_color = Color(1, 1, 0)
	abstract_composition.update_meshPrefabs(curPlinth, Color(1, 1, 0))
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_visible(false)


func _on_blue_pressed():
	curPlinth.material_override = StandardMaterial3D.new()
	curPlinth.material_override.albedo_color = Color(0, 0, 1)
	abstract_composition.update_meshPrefabs(curPlinth, Color(0, 0, 1))
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	set_visible(false)
