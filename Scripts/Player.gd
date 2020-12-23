extends KinematicBody2D

var normal = preload("res://Animations/normal-animation.tres")
onready var death_particles = preload("res://Scenes/Particles/PlayerDeathParticles.tscn")

export var GRAVITY = 1000
export var SPEED = 200
export var JUMP_FORCE = -200
export var JUMP_TIME = 0.1
export var max_jumps = 1

var jumps_left = max_jumps
var is_jumping = false

var velocity = Vector2.ZERO

var facing_right = true
var can_move = false

onready var level_controller = get_parent().get_node("LevelController")

onready var animation = $AnimatedSprite
onready var jump_timer = $JumpTimer

enum {
	IDLE,
	RUN,
	JUMP,
	FALL,
	LAND,
}

var state = IDLE

var flor

func _ready():
	animation.frames = normal

func _physics_process(delta):
	var walk_right = Input.get_action_strength("ui_right")
	var walk_left = Input.get_action_strength("ui_left")
	var jump_stop = !Input.is_action_pressed("ui_jump")
	
	var move = walk_right - walk_left
	
	flor = is_on_floor()
	
	velocity.y += delta * GRAVITY
	
	jump(JUMP_TIME)
	
	match state:
		IDLE:
			animation.play("idle")
			velocity.x = 0
			if can_move:
				if move != 0:
					state = RUN
				if jump_timer.time_left > 0 and jumps_left > 0:
					state = JUMP
		
		RUN:
			animation.play("run")
			if can_move:
				move(move)
				if move == 0:
					state = IDLE
				if !is_on_floor():
					jumps_left = 0
					state = FALL
				if jump_timer.time_left > 0 and jumps_left > 0:
					state = JUMP
		
		JUMP:
			animation.play("jump")
			if can_move:
				move(move)
				if Input.is_action_pressed("ui_jump") and !is_jumping:
					is_jumping = true
					jumps_left -= 1
					velocity.y = JUMP_FORCE
				if jump_stop and velocity.y < 0:
					velocity.y *= 0.5
				if velocity.y > 0:
					state = FALL
				if jump_timer.time_left > 0 and jumps_left > 0:
					state = JUMP
		
		FALL:
			animation.play("fall")
			if can_move:
				if is_on_floor():
					state = LAND
				else:
					move(move)
				if jump_timer.time_left > 0 and jumps_left > 0:
					is_jumping = false
					state = JUMP
			
		LAND:
			animation.play("land")
			is_jumping = false
			jumps_left = max_jumps
			if can_move:
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
	else:
		var vel = Vector2(0, velocity.y)
		velocity = velocity.move_toward(vel, SPEED)

func jump(duration):
	if Input.is_action_just_pressed("ui_jump"):
		jump_timer.start(duration)
		
func death():
	var particles = death_particles.instance()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.emitting = true
	queue_free()
	level_controller.start_death_timer(1)

func power_up(item_name):
	if item_name == "DOUBLE_JUMP":
		max_jumps = 2
		jumps_left += 1

func _on_AnimatedSprite_animation_finished():
	if animation.animation == "land":
		if velocity.x != 0:
			state = RUN
		else:
			state = IDLE

func _on_MoveTimer_timeout():
	can_move = true
