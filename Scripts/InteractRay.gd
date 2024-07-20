extends RayCast3D

func _ready():
	add_exception(owner)
	
func _physics_process(_delta):
	if is_colliding():
		var col = get_collider()
		if col is Interaction:
			#print("Found interaction: ", col.name)
			if Input.is_action_just_pressed("interact"):
				col.interact(owner)
