extends KinematicBody2D

var normal = preload("res://Animations/normal-animation.tres")
var glass = preload("res://Animations/glass-animation.tres")
var pirate = preload("res://Animations/pirate-animation.tres")

onready var death_particles = preload("res://Scenes/Particles/PlayerDeathParticles.tscn")
onready var wings = preload("res://Scenes/Wings.tscn")

export var GRAVITY = 1000
export var SPEED = 200
export var SPRING_FORCE = -540
export var JUMP_FORCE = -200
export var JUMP_TIME = 0.1
export var max_jumps = 1

var jumps_left = max_jumps
var is_jumping = false
var was_grounded = false
var is_coyot_run = false

var unlock_dash = false
var speed_dash_side = 400
var speed_dash_up = 300
var dash_time = 0.2
var can_dash = true
var is_dashing = false

var unlock_fly = false
var is_flying = false

var unlock_invert = false
var is_invert = false

var unlock_slow = false
var is_slow_time = false

var velocity = Vector2.ZERO

var facing_right = true
var can_move = false

onready var level_controller = get_parent().get_node("LevelController")

onready var animation = $AnimatedSprite
onready var jump_timer = $JumpTimer
onready var dash_timer = $DashTimer
onready var coyot_timer = $CoyotTimer
onready var wing_spawner = $WingSpawner
onready var bounce_rays = $BounceRays

enum {
	IDLE,
	RUN,
	JUMP,
	FALL,
	LAND,
	DASH,
	FLY,
	SPRING,
}

var state = IDLE

func _ready():
	choose_char()

func _physics_process(delta):
	var walk_right = Input.get_action_strength("ui_right")
	var walk_left = Input.get_action_strength("ui_left")
	var walk_up = Input.get_action_strength("ui_up")
	var walk_down = Input.get_action_strength("ui_down")
	var jump_stop = !Input.is_action_pressed("ui_jump")
	
	var move = walk_right - walk_left
	
	var move_y = walk_up - walk_down
	
	check_bounce(delta)
	
	if not is_dashing:
		velocity.y += delta * GRAVITY
		jump(JUMP_TIME)
		
	if (not is_invert and is_on_floor()) or (is_invert and is_on_ceiling()):
		is_jumping = false
		is_coyot_run = false
		was_grounded = true
		jumps_left = max_jumps
		if not is_dashing:
			can_dash = true
	else:
		if not is_coyot_run:
			is_coyot_run = true
			coyot_timer.start(.07)
	
	if Input.is_action_just_pressed("ui_slowtime") and unlock_slow:
		if not is_slow_time:
			slow_down_time()
		else:
			restore_time()
	
	match state:
		IDLE:
			animation.play("idle")
			velocity.x = 0
			if can_move:
				if move != 0:
					state = RUN
				if jump_timer.time_left > 0 and jumps_left > 0:
					state = JUMP
				if (velocity.y > 0 and not is_on_floor()) or (velocity.y < 0 and not is_on_ceiling()):
					state = FALL
				if Input.is_action_just_pressed("ui_fly") and unlock_fly:
					state = FLY
				if Input.is_action_just_pressed("ui_invert") and unlock_invert:
					invert()
		
		RUN:
			animation.play("run")
			if can_move:
				move(move)
				if move == 0:
					state = IDLE
				if Input.is_action_just_pressed("ui_dash") and unlock_dash and can_dash and move != 0:
					state = DASH
				if not was_grounded:
					jumps_left = 0
					state = FALL
				if jump_timer.time_left > 0 and jumps_left > 0:
					state = JUMP
				if Input.is_action_just_pressed("ui_fly") and unlock_fly:
					state = FLY
				if Input.is_action_just_pressed("ui_invert") and unlock_invert:
					invert()
		
		JUMP:
			animation.play("jump")
			if can_move:
				move(move)
				if Input.is_action_pressed("ui_jump") and not is_jumping:
					is_jumping = true
					jumps_left -= 1
					velocity.y = JUMP_FORCE
				if not is_invert:
					if jump_stop and velocity.y < 0:
						velocity.y *= 0.5
					if velocity.y > 0:
						state = FALL
				elif is_invert:
					if jump_stop and velocity.y > 0:
						velocity.y *= -0.5
					if velocity.y < 0:
						state = FALL
				if jump_timer.time_left > 0 and jumps_left > 0:
					state = JUMP
				if Input.is_action_just_pressed("ui_dash") and unlock_dash and can_dash and move != 0:
					state = DASH
				if Input.is_action_just_pressed("ui_fly") and unlock_fly:
					state = FLY
				if Input.is_action_just_pressed("ui_invert") and unlock_invert:
					invert()
		
		FALL:
			animation.play("fall")
			if can_move:
				if (not is_invert and is_on_floor()) or (is_invert and is_on_ceiling()):
					state = LAND
				else:
					move(move)
				if jump_timer.time_left > 0 and jumps_left > 0:
					is_jumping = false
					state = JUMP
				if Input.is_action_just_pressed("ui_dash") and unlock_dash and can_dash and move != 0:
					state = DASH
				if Input.is_action_just_pressed("ui_fly") and unlock_fly:
					state = FLY
				if Input.is_action_just_pressed("ui_invert") and unlock_invert:
					invert()
			
		LAND:
			animation.play("land")
			if can_move:
				move(move)
				if move == 0:
					velocity.x = 0
				if jump_timer.time_left > 0:
					if (not is_invert and is_on_floor()) or (is_invert and is_on_ceiling()):
						state = JUMP
				if Input.is_action_just_pressed("ui_dash") and unlock_dash and can_dash and move != 0:
					state = DASH
				if Input.is_action_just_pressed("ui_fly") and unlock_fly:
					state = FLY
				if Input.is_action_just_pressed("ui_invert") and unlock_invert:
					invert()

		DASH:
			animation.play("dash")
			if can_move and not is_dashing:
				velocity.y = 0
				can_dash = false
				is_dashing = true
				dash_timer.start(dash_time)
				if walk_right:
					velocity.x = speed_dash_side
				if walk_left:
					velocity.x = -speed_dash_side
		
		FLY:
			animation.play("fly")
			if can_move:
				if not is_flying:
					var wings_instance = wings.instance()
					wing_spawner.add_child(wings_instance)
					can_dash = true
					jumps_left = 0
					if is_on_floor():
						position.y -= 2
				is_flying = true
				fly(move, move_y)
				if is_invert:
					if is_on_ceiling():
						position.y += 5
					invert()
				if Input.is_action_just_pressed("ui_fly"):
					is_flying = false
					wing_spawner.get_node("Wings").queue_free()
					state = IDLE
				if Input.is_action_just_pressed("ui_dash") and unlock_dash and can_dash and move != 0:
					state = DASH
		
		SPRING:
			animation.play("jump")
			move(move)
			if (velocity.y > 0 and not is_invert) or (velocity.y < 0 and is_invert):
				state = FALL
			if Input.is_action_just_pressed("ui_dash") and unlock_dash and can_dash and move != 0:
				state = DASH
			if Input.is_action_just_pressed("ui_fly") and unlock_fly:
				state = FLY
			if Input.is_action_just_pressed("ui_invert") and unlock_invert:
				invert()
	
	if facing_right and walk_left and not walk_right and not is_dashing:
		flip()
	elif not facing_right and walk_right and not walk_left and not is_dashing:
		flip()
	

	var snap = Vector2.DOWN if not is_jumping else Vector2.ZERO

	velocity = move_and_slide_with_snap(velocity, snap, Vector2(0, -1))

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

func fly(move_x, move_y):
	if not is_dashing:
		if move_x > 0:
			velocity.x = SPEED
		elif move_x < 0:
			velocity.x = -SPEED
		else:
			var vel = Vector2(0, velocity.y)
			velocity = velocity.move_toward(vel, SPEED)
		if move_y > 0:
			velocity.y = -SPEED
		elif move_y < 0:
			velocity.y = SPEED
		else:
			var vel = Vector2(velocity.x, 0)
			velocity = velocity.move_toward(vel, SPEED)

func jump(duration):
	if Input.is_action_just_pressed("ui_jump") and not is_flying:
		jump_timer.start(duration)
		
func death():
	if is_slow_time:
		restore_time()
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
	if item_name == "DASH":
		unlock_dash = true
	if item_name == "FLY":
		unlock_fly = true
	if item_name == "INVERT_GRAVITY":
		unlock_invert = true
	if item_name == "SLOW_TIME":
		unlock_slow = true

func invert():
	GRAVITY *= -1
	JUMP_FORCE *= -1
	animation.flip_v = !animation.flip_v
	jumps_left = 0
	is_invert = !is_invert

func slow_down_time():
	animation.speed_scale *= 2
	SPEED *= 2
	JUMP_FORCE *= 2
	SPRING_FORCE *= 2
	GRAVITY *= 4
	speed_dash_side *= 2
	speed_dash_up *= 2
	dash_time /= 2
	is_slow_time = true
	Engine.time_scale = 0.5

func restore_time():
	animation.speed_scale /= 2
	SPEED /= 2
	JUMP_FORCE /= 2
	SPRING_FORCE /= 2
	GRAVITY /= 4
	speed_dash_side /= 2
	speed_dash_up /= 2
	dash_time *= 2
	is_slow_time = false
	Engine.time_scale = 1

func check_bounce(delta):
	if velocity.y > 0 and not is_flying:
		for raycast in bounce_rays.get_children():
			raycast.cast_to = Vector2.DOWN * velocity * delta + Vector2.DOWN
			raycast.force_raycast_update() 
			if raycast.is_colliding() and raycast.get_collision_normal() == Vector2.UP:
				velocity.y = (raycast.get_collision_point() - raycast.global_position - Vector2.DOWN).y / delta
				raycast.get_collider().entity.call_deferred("bounce", self)
				break
	
func spring():
	velocity.y = SPRING_FORCE
	state = SPRING

func get_pencil():
	level_controller.pencil = true

func choose_char():
	match GameManager.char_choosed:
		GameManager.NORMAL:
			animation.frames = normal
		GameManager.GLASS:
			animation.frames = glass
		GameManager.PIRATE:
			animation.frames = pirate

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
	if not is_flying:
		state = IDLE
	else:
		can_dash = true
		state = FLY

func _on_CoyotTimer_timeout():
	was_grounded = false
