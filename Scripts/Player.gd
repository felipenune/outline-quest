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

var unlock_dash = false
var speed_dash_side = 400
var speed_dash_up = 300
var dash_time = 0.2
var can_dash = true
var is_dashing = false

var velocity = Vector2.ZERO

var facing_right = true
var can_move = false

onready var level_controller = get_parent().get_node("LevelController")

onready var animation = $AnimatedSprite
onready var jump_timer = $JumpTimer
onready var dash_timer = $DashTimer

enum {
	IDLE,
	RUN,
	JUMP,
	FALL,
	LAND,
	DASH,
}

var state = IDLE

func _ready():
	animation.frames = normal

func _physics_process(delta):
	var walk_right = Input.get_action_strength("ui_right")
	var walk_left = Input.get_action_strength("ui_left")
	var jump_stop = !Input.is_action_pressed("ui_jump")
	
	var move = walk_right - walk_left
	
	if not is_dashing:
		velocity.y += delta * GRAVITY
		jump(JUMP_TIME)
		
	if is_on_floor():
		is_jumping = false
		jumps_left = max_jumps
		if not is_dashing:
			can_dash = true
	
	match state:
		IDLE:
			animation.play("idle")
			velocity.x = 0
			if can_move:
				if move != 0:
					state = RUN
				if jump_timer.time_left > 0 and jumps_left > 0:
					state = JUMP
				if velocity.y > 0 and not is_on_floor():
					state = FALL
		
		RUN:
			animation.play("run")
			if can_move:
				move(move)
				if move == 0:
					state = IDLE
				if Input.is_action_just_pressed("ui_dash") and can_dash and move != 0:
					state = DASH
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
				if Input.is_action_just_pressed("ui_dash") and can_dash and move != 0:
					state = DASH
		
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
				if Input.is_action_just_pressed("ui_dash") and can_dash and move != 0:
					state = DASH
			
		LAND:
			animation.play("land")
			if can_move:
				move(move)
				if move == 0:
					velocity.x = 0
				if jump_timer.time_left > 0 and is_on_floor():
					state = JUMP
				if Input.is_action_just_pressed("ui_dash") and can_dash and move != 0:
					state = DASH

		DASH:
			if can_move and not is_dashing:
				velocity.y = 0
				can_dash = false
				is_dashing = true
				dash_timer.start(dash_time)
				if walk_right:
					velocity.x = speed_dash_side
				if walk_left:
					velocity.x = -speed_dash_side
	
	if facing_right and walk_left and not walk_right and not is_dashing:
		flip()
	elif not facing_right and walk_right and not walk_left and not is_dashing:
		flip()
	
	velocity = move_and_slide(velocity, Vector2(0, -1))

func flip():
	facing_right = not facing_right
	scale.x *= -1

func move(move):
	if not is_dashing:
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


func _on_DashTimer_timeout():
	velocity = Vector2.ZERO
	is_dashing = false
	jumps_left -= 1
	state = IDLE
