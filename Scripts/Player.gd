extends KinematicBody2D

export var GRAVITY = 200
export var SPEED = 200

var velocity = Vector2.ZERO

var facing_right = true

onready var animation = $AnimatedSprite

enum {
	IDLE,
	RUN
}

var state = IDLE

func _physics_process(delta):
	var walk_right = Input.get_action_strength("ui_right")
	var walk_left = Input.get_action_strength("ui_left")
	
	var move = walk_right - walk_left
	
	velocity.y += delta * GRAVITY
	
	match state:
		IDLE:
			animation.play("idle")
			velocity.x = 0
			if move != 0:
				state = RUN
		
		RUN:
			animation.play("run")
			if move > 0:
				velocity.x = SPEED
			elif move < 0:
				velocity.x = -SPEED
			else:
				state = IDLE
	
	if facing_right and walk_left:
		flip()
	elif not facing_right and walk_right:
		flip()
	
	velocity = move_and_slide(velocity, Vector2(0, -1))

func flip():
	facing_right = not facing_right
	scale.x *= -1
