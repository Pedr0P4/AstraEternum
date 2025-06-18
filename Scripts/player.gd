class_name Player
extends CharacterBody2D

@onready var player_sprite: AnimatedSprite2D = $PlayerSprites;
@onready var player_collider: CollisionShape2D = $PlayerCollision;
const VELOCITY: int = 150;
var is_with_component: bool;

func _ready() -> void:
	is_with_component = false;

func _process(delta: float) -> void:
	var globalM_pos: Vector2 = get_global_mouse_position();
	var x_cap: float = abs(globalM_pos.y - position.y)*1.2;
	if velocity != Vector2.ZERO:
		if globalM_pos.y > position.y:
			player_sprite.play("Move_down");
		elif (globalM_pos.x < global_position.x + x_cap && globalM_pos.x > global_position.x - x_cap):
			player_sprite.play("Move_up");
		else:
			player_sprite.play("Move_down");
	else:
		if globalM_pos.y <= position.y && (globalM_pos.x < position.x + x_cap && globalM_pos.x > position.x - x_cap):
			player_sprite.play("IdleB");
		else:
			player_sprite.play("IdleF");

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down");
	velocity = direction * VELOCITY;
	$LaserGun.look_at(get_global_mouse_position());
	
	move_and_slide();
