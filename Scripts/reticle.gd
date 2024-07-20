extends CenterContainer

@export var ret_radius: float = 1.0
@export var ret_color: Color = Color.WHITE

func _ready():
	queue_redraw()

func _draw():
	draw_circle(Vector2(0,0), ret_radius, ret_color)
