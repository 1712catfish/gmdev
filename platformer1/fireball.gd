extends Area2D

onready var Count = get_node("Timer")
export var speed  = 500
export var x = 1
export var y = 0

func _ready():
	set_process(true)
	Count.one_shot = true
	Count.wait_time = 0.3
	Count.start()

func _process(delta):
	var motion = Vector2(x,y) * speed
	self.position += motion * delta

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
