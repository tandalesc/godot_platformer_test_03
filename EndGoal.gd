extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "body_entered")
	
func body_entered(body):
	if body.name == 'Player':
		var label = get_parent().get_node('GoalText')
		if !label.visible:
			label.clear()
			label.add_text('You escaped the dungeon.\nPress Alt+F4 to Quit.')
			label.set_position(body.get_node('Camera2D').get_camera_screen_center() + Vector2.DOWN*100 + Vector2.LEFT*label.rect_size.x/2)
			label.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
