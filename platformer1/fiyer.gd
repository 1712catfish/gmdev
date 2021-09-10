extends KinematicBody2D

#only for moving:
var POSITION = 1
var canAttack = 1
onready var DelayTimer = get_node("Timer")
const fireball = preload("enemyFire.tscn")


export var attack_damage = 10



export ( float ) var max_health = 100
onready var health = max_health 
var first_time = true

func killed():
	#the animation and sprite will be added later
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	$TextureProgress.value = health
	if health == 0:
		$TextureProgress.visible = false
		$AnimationPlayer.play("die")
		countDown(0.48)
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

func fire():
	var shot = fireball.instance()
	get_parent().add_child(shot)
	shot.position = $Position2D.global_position
	if $RayCast2D2.cast_to == Vector2(-400,0):
		shot.x *= -1; 
		shot.rotation_degrees = 180
	else:
		shot.rotation_degrees = 0
	pass

func attack():
	var collider
	collider = $RayCast2D2.get_collider()
	if (collider is KinematicBody2D and canAttack == 1):
		fire()
		$AudioStreamPlayer2D.play()
		canAttack = 0
		countDown(1)

func countDown(a):
	DelayTimer.one_shot = true;
	DelayTimer.wait_time = a;
	DelayTimer.start()
	pass

func _physics_process(delta):
	#var space_rid = get_world_2d().space
	#var space_state = Physics2DServer.space_get_direct_state(space_rid)
	if health == 0: return
	$AnimationPlayer.play("Aiming-bot")
	attack()

func _on_Timer_timeout():
	canAttack = 1
	$AudioStreamPlayer2D.play()
	if(health == 0): killed();
	pass # Replace with function body.
