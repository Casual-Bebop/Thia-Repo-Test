extends CollisionObject3D
class_name  Interaction

signal  interacted

func interact(body):
	print(body.name, " interacted with ", name)
	interacted.emit()
