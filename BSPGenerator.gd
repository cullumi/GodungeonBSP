extends Reference

class_name BSPGen

enum AXES {X, Y}
enum {X, Y}

const counters = ["OOB_Area", "InB_Area", "Nodes"]

static func generateBSP(xmin, xmax, ymin, ymax, axis, min_area, min_side=20):
	Counters.make(counters)
	randomize()
	var bsp:BSPNode = generateBSP_r(Vector2(xmin, ymin), Vector2(xmax, ymax), axis, min_area, min_side)
	Counters.pops(counters)
	return bsp

static func othax(axis:int):
	match axis:
		X: return Y
		Y: return X

static func generateBSP_r(mins:Vector2, maxes:Vector2, axis:int, min_area:float, min_side:float):
	if out_of_bound(mins, maxes, min_area, min_side):
		return null;
	var oxis:int = othax(axis)
	var o_size = maxes[oxis] - mins[oxis]
	var min_a_size = max(min_area / o_size, min_side)
	var low = mins[axis] + min_a_size
	var high = maxes[axis] - min_a_size
	var z = -1
	var n1 = null
	var n2 = null
	if high > low:
		z = rand_range(low, high) #some random value between amin and amax
		var lmaxes = maxes
		lmaxes[axis] = z 
		var rmins = mins
		rmins[axis] = z
		var randAxis = randi()%2
		n1 = generateBSP_r(mins, lmaxes, randAxis, min_area, min_side);
		n2 = generateBSP_r(rmins, maxes, randAxis, min_area, min_side);
	Counters.increment("Nodes")
	return BSPNode.new(axis, z, n1, n2)

static func out_of_bound(mins, maxes, min_area=-INF, min_side=-INF):
	var xside = maxes.x-mins.x
	var yside = maxes.y-mins.y
	var area = xside * yside
	var oob = area < min_area or xside < min_side or yside < min_side
	if oob:
		Counters.increment("OOB_Area")
	else:
		Counters.increment("InB_Area")
	return oob
