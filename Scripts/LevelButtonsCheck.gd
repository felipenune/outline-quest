extends Button

var level

func _ready():
	level = self.text.split(' ')[1]

func _process(_delta):
	if int(level) > GameManager.last_unlocked_level:
		self.disabled = true
	else:
		self.disabled = false
