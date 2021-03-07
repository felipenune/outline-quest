extends AnimatedSprite

func _ready():
	if GameManager.char_choosed == GameManager.PIRATE:
		offset.y = -8
