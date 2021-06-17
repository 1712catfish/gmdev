extends TextureProgress

onready var health_bar = $Healthbar

func _on_health_updated(health):
	health_bar.value = health

func _on_max_health_updated(max_health):
	health_bar.max_value = max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
