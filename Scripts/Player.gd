extends KinematicBody2D

var normal = preload("res://Animations/normal-animation.tres")

export var GRAVITY = 1000
export var SPEED = 200
export var JUMP_FORCE = -200
export var JUMP_TIME = 0.1

var velocity = Vector2.ZERO

var facing_right = true

onready var animation = $AnimatedSprite
onready var jump_timer = $JumpTimer

enum {
	IDLE,
	RUN,
	JUMP,
	FALL,
	LAND
}

var state = IDLE

func _ready():
	animation.frames = normal

func _physics_process(delta):
	var walk_right = Input.get_action_strength("ui_right")
	var walk_left = Input.get_action_strength("ui_left")
	var jump_stop = Input.is_action_just_released("ui_jump")
	
	var move = walk_right - walk_left
	
	velocity.y += delta * GRAVITY
	
	jump(JUMP_TIME)
	
	match state:
		IDLE:
			animation.play("idle")
			velocity.x = 0
			if move != 0:
				state = RUN
			if jump_timer.time_left > 0 and is_on_floor():
				state = JUMP
		
		RUN:
			animation.play("run")
			move(move)
			if move == 0:
				state = IDLE
			if jump_timer.time_left > 0 and is_on_floor():
				state = JUMP
		
		JUMP:
			animation.play("jump")
			move(move)
			if is_on_floor():
				velocity.y = JUMP_FORCE
			if jump_stop and velocity.y < 0:
				velocity.y *= 0.5
			if velocity.y > 0:
				state = FALL
		
		FALL:
			animation.play("fall")
			if is_on_floor():
				state = LAND
			else:
				move(move)
			
		LAND:
			animation.play("land")
			move(move)
			if move == 0:
				velocity.x = 0
			if jump_timer.time_left > 0 and is_on_floor():
				state = JUMP
	
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

func jump(duration):
	var jump = Input.is_action_just_pressed("ui_jump")
	if jump:
		jump_timer.start(duration)

func _on_AnimatedSprite_animation_finished():
	if animation.animation == "land":
		if velocity.x != 0:
			state = RUN
		else:
			state = IDLE
