extends Area2D

onready var Count = get_node("Timer")
export var speed  = 500
export var x = 1
export var y = 0

func _ready():
	set_process(true)
	countDown(0.3)

func _process(delta):
	var motion = Vector2(x,y) * speed
	self.position += motion * delta

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.

func countDown(a):
	Count.one_shot = true;
	Count.wait_time = a;
	Count.start()
	pass

func _on_fireball_body_entered(body):
	if body.is_in_group("enemy"):
		body.attacked(10)
		queue_free()
	
	pass # Replace with function body.
