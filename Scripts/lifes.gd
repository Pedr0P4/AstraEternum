extends Container
class_name Lifes

signal player_died

const MAX_UNIQUE_LIFE: int = 2;

@onready var lifes: Array = $Lifes.get_children();
var life_amount: int;
var lifes_amount: int;
var actual_life_icon: int;
var died: bool;

func _ready() -> void:
	for i in range(lifes.size()):
		life_amount += lifes[i].amount;
	lifes_amount = lifes.size();
	actual_life_icon = 0;

func _process(delta: float) -> void:
	if !died:
		if actual_life_icon == 2 && lifes[actual_life_icon].amount == 0:
			player_died.emit();
			died = true;

func take_damage(amount: int) -> void:
	var total = amount;
	while total > 0:
		if total > lifes[actual_life_icon].amount:
			total -= lifes[actual_life_icon].amount;
			lifes[actual_life_icon].lose(lifes[actual_life_icon].amount);
			actual_life_icon += 1;
		else:
			lifes[actual_life_icon].lose(total);
			total = 0;
