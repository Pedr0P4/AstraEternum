extends Node
class_name GameController

@export var player: Player;
@export var spaceship: SpaceShip
@export var component: PackedScene;
var actual_region: int;
var levels : Array[Node];

func _ready() -> void:
	actual_region = 1;
	levels = get_tree().current_scene.get_node("Levels").get_children();

func _process(delta: float) -> void:
	if player.collected:
		change_itens();
		player.collected = false;
	
	if actual_region > 4:
		get_tree().change_scene_to_file("res://Scenes/victory.tscn");

func increment_region() -> void:
	actual_region += 1;
	if player.is_with_component:
		player.is_with_component = false;

func change_itens() -> void:
	for i in range(levels.size()):
		if levels[i].item_inst:
			levels[i].item_inst.change_item(actual_region+1);
