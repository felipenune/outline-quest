extends Button

export var req_pencils = 1
export var char_name: String

onready var sprite = $Sprite
onready var rich_text = $RichTextLabel
onready var moldure = $Moldure

func _process(_delta):
	if GameManager.pencils < req_pencils:
		self.disabled = true
		self.text = "locked"
		moldure.modulate = Color8(90, 90, 90, 255)
		sprite.visible = false
		rich_text.visible = true
		rich_text.text = "P X " + "%02d" % req_pencils
	else:
		self.disabled = false
		self.text = char_name
		moldure.modulate = Color8(255, 255, 255, 255)
		sprite.visible = true
		rich_text.visible = false
