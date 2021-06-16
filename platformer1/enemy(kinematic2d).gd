extends KinematicBody2D

#only for moving:
var POSITION = 1
var movement = Vector2()
const SPEED = 50
const GRAVITY = 2700
const  FLOOR = Vector2(0,-1)



export ( float ) var max_health = 100
onready var health = max_health 
var first_time = true

func killed():
	$Sprite.visible = false
	$TextureProgress.visible = false
	$CollisionShape2D.disabled = true
	set_physics_process(false)

	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	$TextureProgress.value = health
	if health == 0:
		killed()
	if health != prev_health:
		pass
	return health
func attacked(amount):
	health = _set_health(health - amount)
func _ready():
	if first_time:
		$TextureProgress.max_value = max_health
		$TextureProgress.value = max_health
		first_time = false
	pass




export var attack_damage = 1
func attack():
	var collider
	
	collider = $RayCast2D3.get_collider()
	if collider is KinematicBody2D:
		var i = $RayCast2D3.get_collider_shape()
		var body = collider.shape_owner_get_owner(i)
		body.get_parent().attacked(attack_damage)
		print(body.get_parent().health)



func _physics_process(delta):
	#var space_rid = get_world_2d().space
	#var space_state = Physics2DServer.space_get_direct_state(space_rid)
	movement.x = SPEED * POSITION
	movement.y += GRAVITY * delta
	movement = move_and_slide(movement,FLOOR)
	
	var dir = 0
	if is_on_wall():
		POSITION *= -1 
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false: 
		POSITION *= -1
		$RayCast2D.position.x *= -1
		
		
	if(POSITION == -1): 
		$RayCast2D2.enabled = 0
		$RayCast2D3.enabled = 1 
	else:
		$RayCast2D2.enabled = 1
		$RayCast2D3.enabled = 0
	attack()

