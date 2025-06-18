extends TileMapLayer

@export var length := Vector2i(70, 40)
@export var split_count := 4

func divide_room(room: Rect2i) -> Array[Rect2i]:
	var axis: StringName = "x" if room.size.x >= room.size.y else "y"
	var split_percentage := randf_range(0.3, 0.7)
	var subdivision_location: int = lerp(room.position[axis], room.end[axis], split_percentage)

	var first := Rect2i(room)
	first.end[axis] = subdivision_location

	var second := Rect2i(room)
	second.position[axis] = subdivision_location
	second.size[axis] = room.size[axis] - first.size[axis]

	return [first, second]


func subdivide_dungeon(iterations: int, size: Vector2) -> Array[Rect2i]:
	var leaf_nodes := 2 ** iterations
	var total_nodes := 2 * leaf_nodes - 1
	var divisions: Array[Rect2i]
	divisions.resize(total_nodes)

	divisions[0] = Rect2i(Vector2.ZERO, size)

	for i in range(leaf_nodes - 1):
		var subdivisions = divide_room(divisions[i])
		divisions[i * 2 + 1] = subdivisions[0]
		divisions[i * 2 + 2] = subdivisions[1]

	return divisions


func cut_rooms(rooms: Array[Rect2i]) -> Array[Rect2i]:
	var rng := RandomNumberGenerator.new()
	for i in range(rooms.size()):
		var top_left_padding: Vector2i
		if rooms[i].position == Vector2i.ZERO:
			top_left_padding = Vector2i.ZERO
		elif rooms[i].size.x <= 5:
			top_left_padding = Vector2i.ONE
		else:
			top_left_padding = Vector2i(rng.randi_range(1,2), rng.randi_range(1,2))

		var bottom_right_padding: Vector2i
		if rooms[i].size.y <= 5:
			bottom_right_padding = Vector2i.ONE
		else:
			bottom_right_padding = Vector2i(rng.randi_range(1,2), rng.randi_range(1,2))
		
		rooms[i].position += top_left_padding
		rooms[i].size -= bottom_right_padding
	return rooms


func generate_dungeon(iterations: int, size: Vector2) -> Array[Rect2i]:
	var divisions := subdivide_dungeon(iterations, size)
	var leaf_start := 2 ** iterations - 1
	var divisions_leafs = divisions.slice(leaf_start)
	var rooms = cut_rooms(divisions_leafs)

	for x in range(-3, length.x + 3):
		for y in range(-3, length.y + 3):
			set_cell(Vector2(x, y), 0, Vector2(1, 0))

	for r in rooms:
		for x in range(r.position.x, r.end.x):
			for y in range(r.position.y, r.end.y):
				set_cell(Vector2(x, y), 0, Vector2(0, 0))

	var num_parents = (rooms.size() - 1) / 2
	for i in range(num_parents + 1):
		var parent_room = rooms[i]

		var left_child_idx = 2 * i + 1
		if left_child_idx < rooms.size():
			var left_child_room = rooms[left_child_idx]
			create_corridor_between(parent_room, left_child_room)

		var right_child_idx = 2 * i + 2
		if right_child_idx < rooms.size():
			var right_child_room = rooms[right_child_idx]
			create_corridor_between(parent_room, right_child_room)
	return rooms


func create_horizontal_tunnel(x1: int, x2: int, y: int):
	for x in range(min(x1, x2), max(x1, x2) + 1):
		set_cell(Vector2(x, y), 0, Vector2(0, 0))


func create_vertical_tunnel(y1: int, y2: int, x: int):
	for y in range(min(y1, y2), max(y1, y2) + 1):
		set_cell(Vector2(x, y), 0, Vector2(0, 0))


func create_corridor_between(room_a: Rect2i, room_b: Rect2i):
	var center_a = room_a.get_center()
	var center_b = room_b.get_center()

	if randf() > 0.5:
		create_horizontal_tunnel(center_a.x, center_b.x, center_a.y)
		create_vertical_tunnel(center_a.y, center_b.y, center_b.x)
	else:
		create_vertical_tunnel(center_a.y, center_b.y, center_a.x)
		create_horizontal_tunnel(center_a.x, center_b.x, center_b.y)


@onready var enemy_scene := preload("res://Scenes/enemy.tscn")
var rooms: Array[Rect2i]
var enemies: Array[Resource]


func _ready():
	rooms = generate_dungeon(split_count, length)

	var rng := RandomNumberGenerator.new()
	for r in rooms:
		for i in rng.randi_range(3, 5):
			var x = randi_range(r.position.x, r.position.x + r.size.x - 1)
			var y = randi_range(r.position.y, r.position.y + r.size.y - 1)

			var enemy := enemy_scene.instantiate()
			enemy.position = self.map_to_local(Vector2(x, y))
			add_child(enemy)
