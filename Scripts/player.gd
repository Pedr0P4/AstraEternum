extends CharacterBody2D

const VELOCITY: int = 250;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var mouse_pos = get_viewport().get_mouse_position();
	
	if velocity != Vector2.ZERO:
		if mouse_pos.y > position.y:
			$PlayerSprites.play("WalkingDown");
		else:
			$PlayerSprites.play("WalkingUp");
	else:
		if mouse_pos.y > position.y:
			$PlayerSprites.play("IdleF");
		else:
			$PlayerSprites.play("IdleB");
			

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down");
	velocity = direction * VELOCITY;
	
	move_and_slide();
