@tool
extends TileMapLayer

@export var length: Vector2i

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


func generate_dungeon(iterations: int, size: Vector2) -> Array[Rect2i]:
	var divisions := subdivide_dungeon(iterations, size)
	var leaf_start := 2 ** iterations - 1
	return divisions.slice(leaf_start)


func create_horizontal_tunnel(x1: int, x2: int, y: int):
	for x in range(min(x1, x2), max(x1, x2) + 1):
		set_cell(Vector2(x, y), 0, Vector2(0, 0))

# Desenha um túnel vertical
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


var rooms: Array[Rect2i]

func _ready():
	var rng := RandomNumberGenerator.new()
	var split_count := 4

	rooms = generate_dungeon(split_count, length)

	for x in range(length.x):
		for y in range(length.y):
			set_cell(Vector2(x, y), 0, Vector2(1, 0))

	for r in rooms:
		var padding: Vector4i
		if r.size.x <= 5:
			padding.w = 1
			padding.x = 1
		else:
			padding.w = rng.randi_range(1,2)
			padding.x = rng.randi_range(1,2)

		if r.size.y <= 5:
			padding.y = 1
			padding.z = 1
		else:
			padding.y = rng.randi_range(1,2)
			padding.z = rng.randi_range(1,2)

		if r.position == Vector2i.ZERO:
			padding.w = 0
			padding.y = 0

		for x in range(r.position.x + padding.w, r.end.x - padding.x):
			for y in range(r.position.y + padding.y, r.end.y - padding.z):
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
