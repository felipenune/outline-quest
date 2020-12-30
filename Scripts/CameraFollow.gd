extends Position2D


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
		if position.x < player.position.x and position.x < right_limit:
			move_x()
		elif position.x > player.position.x and position.x > left_limit: 
			move_x()

func move_x():
	position.x = lerp(position.x, player.position.x, 0.7)
