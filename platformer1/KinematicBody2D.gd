extends KinematicBody2D

const GRAVITY = 2700
const SPEED = 300
var velocity = Vector2()
export var attack_damage = 5
onready var direction = 0
const fireball = preload("fireball.tscn")

var onattack = false 
var canjump = true 
var iskilled = false 
var isHit = false
onready var delaytimer = get_node("Timer") #control count down time

func run():
	if(is_on_wall() or is_on_floor() and !onattack and !iskilled):
		$AnimationPlayer.play("run")

func idle():
	if((is_on_wall() or is_on_floor()) and !onattack and !iskilled):
		if ($AnimationPlayer.current_animation != "idle"):
			$AnimationPlayer.play("idle")

func jump():
	if((is_on_wall() or is_on_floor()) and canjump and !iskilled):
		$AnimationPlayer.play("jump")
		canjump = false;
		delaytimer.one_shot = true;
		delaytimer.wait_time = 0.5;
		delaytimer.start()

func fire():
	var shot = fireball.instance()
	get_parent().add_child(shot)
	shot.position = $Position2D.global_position
	if $RayCast2D.cast_to == Vector2(-60,0):
		shot.x *= -1; 
		shot.rotation_degrees = 180
	else:
		shot.rotation_degrees = 0
	
	pass

func get_input():
	if iskilled or isHit: return
	# run left & right
	direction = 0
	if Input.is_action_pressed("ui_left") and !onattack:
		direction = -1
		$RayCast2D.cast_to = Vector2(-60,0)

	if Input.is_action_pressed("ui_right") and !onattack:
		direction = 1
		$RayCast2D.cast_to = Vector2(60,0)
	
	if direction == 0: 
		idle()
	else: 
		$Sprite.set_flip_h(bool(1 - direction))
		run()
	if Input.is_action_just_pressed("ui_accept"):
		attack()
		$AnimationPlayer.play("attack")
		#if(Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")):
		fire()
		delaytimer.one_shot = true;
		delaytimer.wait_time = 0.4;
		delaytimer.start()
		# Turn RayCast2D toward movement direction
		#if directray.x != direction :
		#	directray.x = direction
		#	$RayCast2D.cast_to = directray.normalized() * 50
		
	velocity.x = direction * SPEED
	
	# jump
	if Input.is_action_just_pressed("ui_up") and canjump:
		jump()
		if is_on_wall():
			velocity.y -= float(GRAVITY / 3)

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	get_input()
	velocity = move_and_slide(velocity)

func attack():
	var collider = 0
	#fire()
	collider = $RayCast2D.get_collider()
	if collider is KinematicBody2D:
		var i = $RayCast2D.get_collider_shape()
		var body = collider.shape_owner_get_owner(i)
		body.get_parent().attacked(attack_damage)
		#print(body.get_parent().health)
		$AnimationPlayer.play("attack")
	onattack = true;

# damage-reciver
export ( float ) var max_health = 100
onready var health = max_health setget _set_health
var first_time = true

func killed():
	$AnimationPlayer.play("killed")
	iskilled = true
	delaytimer.one_shot = true;
	delaytimer.wait_time = 0.6;
	delaytimer.start()
	$Healthbar.visible = false

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	$Healthbar.value = health
	if health == 0:
		killed()
	else: 
		$AnimationPlayer.play("hit")
		isHit = true
		delaytimer.one_shot = true;
		delaytimer.wait_time = 0.3;
		delaytimer.start()
	if health != prev_health:
		pass
	return health

func attacked(amount):
	health = _set_health(health - amount)
	
func _ready():
	if first_time:
		$Healthbar.max_value = max_health
		$Healthbar.value = max_health
		first_time = false
	pass

func _on_Timer_timeout():
	onattack = false
	canjump = true
	isHit = false
	if health == 0: get_tree().quit()
	pass
