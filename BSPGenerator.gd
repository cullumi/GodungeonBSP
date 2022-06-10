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

#static func generateBSP_r(xmin, xmax, ymin, ymax, axis, min_area, min_side):
#
#	if out_of_bound(xmax, xmin, ymax, ymin, min_area):
#		return null;
#	if axis == X:
#		var y_size = ymax - ymin
#		var min_x_size = max(min_area / y_size, min_side)
##		prints("min_x:", min_x_size)
#		var low = xmin + min_x_size
#		var high = xmax - min_x_size
#		var z = -1
#		var n1 = null
#		var n2 = null
#		if high > low:
#			z = rand_range(low, high) #some random value between xmin and xmax
#			n1 = generateBSP_r(xmin, z, ymin, ymax, Y, min_area, min_side);
#			n2 = generateBSP_r(z, xmax, ymin, ymax, Y, min_area, min_side);
#		return BSPNode.new(X, z, n1, n2)
#		#new BSP node with axis = X, dividing point = z, and children n1 and n2.
#	elif axis == Y:
#		var x_size = xmax - xmin
#		var min_y_size = max(min_area / x_size, min_side)
##		prints("min_y:", min_y_size)
#		var low = ymin + min_y_size
#		var high = ymax - min_y_size
#		var z = -1
#		var n1 = null
#		var n2 = null
#		if high > low:
#			z = rand_range(low, high) #some random value between ymin and ymax
#			n1 = generateBSP_r(xmin, xmax, ymin, z, X, min_area, min_side);
#			n2 = generateBSP_r(xmin, xmax, z, ymax, X, min_area, min_side);
#		return BSPNode.new(Y, z, n1, n2)
#		#new BSP node with axis = Y, dividing point = z, and children n1 and n2.

#static func out_of_bound(xmax, xmin, ymax, ymin, min_area=-INF, min_side=-INF):
#	var xside = xmax-xmin
#	var yside = ymax-ymin
#	var area = xside * yside
#	var oob = area < min_area or xside < min_side or yside < min_side
#	if oob:
#		Counters.increment("OOB_Area")
#	else:
#		Counters.increment("InB_Area")
#	return oob 
