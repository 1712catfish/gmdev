extends Node2D
onready var animated_sprite = $AnimatedSprite

var velocity = Vector2.ZERO
var maxrun = 100
var accel = 800
var gravity = 1000
var fall = 160

func _process(delta):
	var direction = sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if direction == 0:
		animated_sprite.play("idle")
	
	velocity.x = move_toward(velocity.x, maxrun * direction, accel * delta)
	velocity.y = move_toward(velocity.y, fall, gravity * delta)
	
	global_position.x += (velocity.x * delta)
	
