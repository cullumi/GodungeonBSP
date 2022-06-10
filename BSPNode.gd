extends Reference

class_name BSPNode

enum {X, Y}

var axis:int
var dividing_point:float
var child1
var child2

func _init(ax:int, div_point:float, ch1, ch2):
	self.axis = ax
	self.dividing_point = div_point
	self.child1 = ch1
	self.child2 = ch2

func get_leaves(arr:Array=[]):
	if not child1 and not child2:
		arr.append(self)
	else:
		if child1: child1.getLeaves(arr)
		if child2: child2.getLeaves(arr)
	return arr
