extends Area2D

export var start_time = 1.0
export var cooldown_time = 1.0
onready var cooldown_timer = $Cooldown
onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	cooldown_timer.start(start_time)

func _on_Spears_body_entered(body):
	if body.has_method("death"):
		body.death()


func _on_Cooldown_timeout():
	animation.play("default")


func _on_AnimationPlayer_animation_finished(_anim_name):
	cooldown_timer.start(cooldown_time)
