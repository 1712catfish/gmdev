extends KinematicBody2D

const up = Vector2(0, -1)
const GRAVITY = 2700
const SPEED = 300
const ACCELERATION = 50
const jump_height = -550
var motion = Vector2()
export var attack_damage = 5


func _physics_process(_delta):
	motion.y += GRAVITY
	var friction = false
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, SPEED)
		$Sprite.flip_h = false
		$Sprite.play("run")
	elif Input.is_action_pressed("ui_left"):
		motion.x =max(motion.x - ACCELERATION, SPEED)
		$Sprite.flip_h = true
		$Sprite.play("run")
	else:
		$Sprite.play("idle")
		friction = true
		motion.x = lerp(motion.x, 0, 0.2)
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = jump_height
		if friction == true:
			motion.x = lerp(motion.x, 0 , 0.05)
	else:
		$Sprite.play("jump")
	motion = move_and_slide(motion, up)
	pass
		


func attack():
	var collider
	
	collider = $RayCast2D.get_collider() and Input.is_action_pressed("ui_accept")
	if collider is KinematicBody2D:
		var i = $RayCast2D.get_collider_shape()
		var body = collider.shape_owner_get_owner(i)
		body.get_parent().attacked(attack_damage)
		#print(body.get_parent().health)
		$AnimationPlayer.play("attack")
		
	collider = $RayCast2D2.get_collider()
	if collider is KinematicBody2D:
		var i = $RayCast2D2.get_collider_shape()
		var body = collider.shape_owner_get_owner(i)
		body.get_parent().attacked(attack_damage)
		#print(body.get_parent().health)
		$AnimationPlayer.play("attack")


# damage-reciver
export ( float ) var max_health = 100
onready var health = max_health setget _set_health
var first_time = true

func killed():
	$Sprite.visible = false
	$Healthbar.visible = false
	$CollisionShape2D.disabled = true
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	$Healthbar.value = health
	if health == 0:
		killed()
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


