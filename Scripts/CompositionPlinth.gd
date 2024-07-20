extends MeshInstance3D

@onready var uiMenu = $"../UI Menu"

func _on_interaction_interacted():
	uiMenu.set_visible(true)
	uiMenu.curPlinth = self
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
