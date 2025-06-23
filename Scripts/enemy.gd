extends CharacterBody2D

signal attack
signal enemy_die

var player_path: NodePath

const SPEED := 75.0
const DETECTION_RADIUS := 100.0

@onready var navigation_agent := $NavigationAgent2D
var player: Node2D
var chasing := false


func _ready():
	player = get_parent().get_node(player_path)


func _physics_process(_delta: float) -> void:
	if not player:
		return

	if chasing:
		navigation_agent.get_path()
		var direction = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = direction * SPEED
		move_and_slide()
	else:
		var distance = global_position.distance_to(player.global_position)
		if distance <= DETECTION_RADIUS:
			chasing = true


func _on_timer_timeout():
	navigation_agent.target_position = player.global_position


func take_damage():
	$EnemyDamagedSound.play_random_audio();
	$CollisionShape2D.disabled = true;
	$Area2D/CollisionShape2D.disabled = true;
	visible = false;


func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group(&"player"):
		body.take_damage(1)


func _on_enemy_damaged_sound_sound_finished() -> void:
	queue_free();
