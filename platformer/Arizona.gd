extends KinematicBody2D

const GRAVITY = 2700
const SPEED = 300

var velocity = Vector2()

func run():
	$AnimationPlayer.play("running")
	
func idle():
	$AnimationPlayer.play("idle")
	
func jump():
	$AnimationPlayer.play("jump")
	
	

func get_input():	
	
	# run left & right
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
	
	if direction == 0: 
		idle()
	else: 
		$Sprite.set_flip_h(bool(1 - direction))
		run()
		
	velocity.x = direction * SPEED
	
	# jump
	if Input.is_action_just_pressed("ui_up"):
		if is_on_wall() or is_on_ceiling():
			velocity.y -= GRAVITY / 3
			jump()
	
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	get_input()
	velocity = move_and_slide(velocity)
