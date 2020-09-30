extends KinematicBody2D

export var GRAVITY = 1000
export var SPEED = 200
export var JUMP_FORCE = -200

var velocity = Vector2.ZERO

var facing_right = true

onready var animation = $AnimatedSprite

enum {
	IDLE,
	RUN,
	JUMP,
	FALL,
	LAND
}

var state = IDLE

func _physics_process(delta):
	var walk_right = Input.get_action_strength("ui_right")
	var walk_left = Input.get_action_strength("ui_left")
	var jump = Input.is_action_just_pressed("ui_jump")
	var jump_stop = Input.is_action_just_released("ui_jump")
	
	var move = walk_right - walk_left
	
	velocity.y += delta * GRAVITY
	
	match state:
		IDLE:
			animation.play("idle")
			velocity.x = 0
			if move != 0:
				state = RUN
			if jump:
				state = JUMP
		
		RUN:
			animation.play("run")
			move(move)
			if move == 0:
				state = IDLE
			if jump:
				state = JUMP
		
		JUMP:
			move(move)
			if is_on_floor():
				velocity.y = JUMP_FORCE
			if jump_stop and velocity.y < 0:
				velocity.y *= 0.5
			if velocity.y > 0:
				state = FALL
		
		FALL:
			if is_on_floor():
				state = LAND
			else:
				move(move)
			
		LAND:
			if velocity.x != 0:
				state = RUN
			else:
				state = IDLE
	
	if facing_right and walk_left and not walk_right:
		flip()
	elif not facing_right and walk_right and not walk_left:
		flip()
	
	velocity = move_and_slide(velocity, Vector2(0, -1))

func flip():
	facing_right = not facing_right
	scale.x *= -1

func move(move):
	if move > 0:
		velocity.x = SPEED
	elif move < 0:
		velocity.x = -SPEED
