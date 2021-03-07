extends Button

var level

onready var moldure = $Moldure

func _ready():
	level = self.text.split(' ')[1]

func _process(_delta):
	if int(level) > GameManager.last_unlocked_level:
		self.disabled = true
		moldure.modulate = Color8(90, 90, 90, 255)
	else:
		self.disabled = false
		moldure.modulate = Color8(255, 255, 255, 255)
