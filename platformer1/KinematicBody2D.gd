extends KinematicBody2D

const GRAVITY = 2700
const SPEED = 300
var velocity = Vector2()
export var attack_damage = 5

func run():
	if(is_on_wall() or is_on_floor()):
		$AnimationPlayer.play("run")

func idle():
	if(is_on_wall() or is_on_floor() ) :
		$AnimationPlayer.play("idle")

func jump():
	if(!is_on_wall() or !is_on_floor()):
		$AnimationPlayer.play("jump")


func get_input():
	var directray = Vector2()
	# run left & right
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
		$RayCast2D.enabled = false
		$RayCast2D2.enabled = true

	if Input.is_action_pressed("ui_right"):
		direction = 1
		$RayCast2D2.enabled = false
		$RayCast2D.enabled = true
	
	if direction == 0: 
		idle()
	else: 
		$Sprite.set_flip_h(bool(1 - direction))
		run()
	if Input.is_action_pressed("ui_accept"):
		$AnimationPlayer.play("attack")
		# Turn RayCast2D toward movement direction
		#if directray.x != direction :
		#	directray.x = direction
		#	$RayCast2D.cast_to = directray.normalized() * 50
		
	velocity.x = direction * SPEED
	
	# jump
	if Input.is_action_just_pressed("ui_up"):
		jump()
		if is_on_wall():
			velocity.y -= GRAVITY / 3
		

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	get_input()
	velocity = move_and_slide(velocity)
	attack()


func attack():
	var collider
	if Input.is_action_just_pressed("ui_accept"):
		collider = $RayCast2D.get_collider()
		if collider is KinematicBody2D:
			var i = $RayCast2D.get_collider_shape()
			var body = collider.shape_owner_get_owner(i)
			body.get_parent().attacked(attack_damage)
			#print(body.get_parent().health)
			$AnimationPlayer.play("attack")
			
	if Input.is_action_pressed("ui_accept"):
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


