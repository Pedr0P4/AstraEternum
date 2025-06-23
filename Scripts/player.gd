class_name Player
extends CharacterBody2D

signal damage_taken(damage: int)

@onready var player_sprite: AnimatedSprite2D = $PlayerSprites
@onready var player_collider: CollisionShape2D = $PlayerCollision
@onready var laser_gun: Node2D = $LaserGun

const MAX_HEALTH := 5
const INVENCIBILITY_TIME := 2.0
const BLINK_INTERVAL := 0.1
const VELOCITY := 150

var current_health := MAX_HEALTH
var is_invincible := false
var invincibility_time_left := 0.0
var blink_time_left := 0.0

var is_with_component: bool
var collected: bool
var is_dead: bool


func _ready() -> void:
	is_with_component = false
	collected = false
	is_dead = false;

func _process(_delta: float) -> void:
	if !is_dead:
		var globalM_pos: Vector2 = get_global_mouse_position()
		var x_cap: float = abs(globalM_pos.y - position.y) * 1.2
		if velocity != Vector2.ZERO:
			if globalM_pos.y > position.y:
				player_sprite.play("Move_down")
			elif (globalM_pos.x < global_position.x + x_cap && globalM_pos.x > global_position.x - x_cap):
				player_sprite.play("Move_up")
			else:
				player_sprite.play("Move_down")
		else:
			if globalM_pos.y <= position.y && (globalM_pos.x < position.x + x_cap && globalM_pos.x > position.x - x_cap):
				player_sprite.play("IdleB")
			else:
				player_sprite.play("IdleF")
	else:
		player_sprite.play("Dying");


func _physics_process(delta: float) -> void:
	if is_invincible:
		invincibility_time_left -= delta
		blink_time_left -= delta

		if blink_time_left <= 0.0:
			visible = not visible
			blink_time_left = BLINK_INTERVAL

		if invincibility_time_left <= 0.0:
			is_invincible = false
			visible = true
	if !is_dead:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * VELOCITY
		laser_gun.look_at(get_global_mouse_position())

		move_and_slide()


func take_damage(amount: int) -> void:
	if is_invincible:
		return
	is_invincible = true
	invincibility_time_left = INVENCIBILITY_TIME
	blink_time_left = 0.0
	visible = true
	damage_taken.emit(amount);
