extends Spatial

export (Vector2) var minExt = Vector2(-50, -50)
export (Vector2) var maxExt = Vector2(50, 50)
export (Vector2) var wallThick = Vector2(0.2, 0.2)
export (BSPGen.AXES) var axis = BSPGen.X
export (float) var min_room_area = 15
export (float) var min_wall_length = 15
export (float) var height = 5
export (float) var cfThick = 0.2

enum {
	OP_UN=CSGShape.OPERATION_UNION,
	OP_INT=CSGShape.OPERATION_INTERSECTION,
	OP_SUB=CSGShape.OPERATION_SUBTRACTION
}

var csg_body
const counters:Array = ["too_small", "just_right", "leaves"]

func _ready():
	Counters.make(counters)
	var bsp = BSPGen.generateBSP(minExt.x, maxExt.x, minExt.y, maxExt.y, axis, min_room_area, min_wall_length)
	spawn_dungeon(bsp, minExt, maxExt)
	Counters.pops(counters)

func _init():
	csg_body = add_csg(self, minExt-wallThick, maxExt+wallThick, height+cfThick, OP_UN)
	csg_body.translation.y = height/2

func spawn_dungeon(bsp:BSPNode, min_ext:Vector2, max_ext:Vector2):
	if bsp == null:
		return
	elif bsp.child1 or bsp.child2:
		var ax_idx = (bsp.axis+1)%2
		var l_mid_ext:Vector2 = max_ext
		l_mid_ext[ax_idx] = bsp.dividing_point
		var r_mid_ext:Vector2 = min_ext
		r_mid_ext[ax_idx] = bsp.dividing_point
		spawn_dungeon(bsp.child1, min_ext, l_mid_ext)
		spawn_dungeon(bsp.child2, r_mid_ext, max_ext)
		print("\nl: ", min_ext, "\nl_mid: ", l_mid_ext, "\nr_mid: ", r_mid_ext, "\nr: ", max_ext)
		spawn_door(ax_idx, r_mid_ext, l_mid_ext)
	else:
		too_small(max_ext, min_ext)
		Counters.count("leaves")
		add_csg(csg_body, min_ext+wallThick, max_ext-wallThick, height, OP_SUB)

func spawn_door(axis:int, rm_min_ext:Vector2, rm_max_ext:Vector2):
	var mid_point:Vector2 = (rm_min_ext + rm_max_ext) / 2
	var offset:Vector2 = Vector2()
	offset[axis] = wallThick[axis] + 0.01
	offset[(axis+1)%2] = 1
	var hght:float = height*2/3
	var v_off:float = (hght-height)/2
	add_csg(csg_body, mid_point-offset, mid_point+offset , hght, OP_SUB, v_off)

func too_small(high_ext:Vector2, low_ext:Vector2):
	if high_ext.x - low_ext.x < 1 or high_ext.y - low_ext.y < 1:
		Counters.increment("too_small")
	else:
		Counters.increment("just_right")

func add_csg(parent:Node, min_ext:Vector2, max_ext:Vector2, hgt:float, op:int=OP_UN, v_offset:float=0):
	var size:Vector2 = max_ext - min_ext
	var pos:Vector2 = min_ext + (size/2)
	var csg = make_csg(pos, size, hgt, op, v_offset)
	parent.add_child(csg)
	return csg

func make_csg(pos, size, hgt, op=OP_UN, v_offset:float=0, use_col=true):
	var csg:CSGShape = CSGBox.new()
	csg.translation = Vector3(pos.x, v_offset, pos.y)
	csg.width = size.x
	csg.height = hgt
	csg.depth = size.y
	csg.operation = op
	csg.use_collision = use_col
	return csg
