extends Position2D

export var y_amount = 360
export var x_amount = 640

export var y_offset = 190
export var x_offset = 320

export var left_limit = 320
export var right_limit = 960

onready var remote_transform = $RemoteTransform2D

onready var player = get_parent().get_node("Player")
onready var cam = get_parent().get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	if cam != null:
		remote_transform.remote_path = cam.get_path()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player != null:
		if player.position.x > position.x + x_offset:
			move_right()
		elif player.position.x < position.x - x_offset: 
			move_left()
			
		if player.position.y > position.y + y_offset:
			move_y_up()
		elif player.position.y < position.y - y_offset:
			move_y_down()

func move_right():
	position.x = position.x + x_amount
	
func move_left():
	position.x = position.x - x_amount

func move_y_up():
	position.y = position.y + y_amount
	
func move_y_down():
	position.y = position.y - y_amount
