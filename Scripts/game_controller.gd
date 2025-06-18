extends Node
class_name GameController

@export var player: Player;
@export var spaceship: SpaceShip
@export var region1: Region;
@export var region2: Region;
@export var region3: Region;
@export var region4: Region;
var actual_region: int;

func _ready() -> void:
	actual_region = 1;

func _process(delta: float) -> void:
	pass

func increment_region() -> void:
	actual_region += 1;
	if player.is_with_component:
		player.is_with_component = false;
