extends Area2D

const SPEED := 350.0

var explosion_scene := preload("res://Scenes/Components/explosion.tscn")
var direction = Vector2.RIGHT


func _ready():
	rotation = direction.angle()


func _process(delta: float) -> void:
	position += direction.normalized() * SPEED * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()

	var explosion_instance = explosion_scene.instantiate()
	explosion_instance.global_position = global_position
	get_parent().add_child(explosion_instance)
	queue_free()
