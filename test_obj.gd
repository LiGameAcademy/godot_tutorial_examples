extends Node2D
class_name TestObj

@export var test_res: TestRes

var i : int:
	set(value):
		test_res.i = value
	get:
		return test_res.i

func _to_string() -> String:
	return "test_obj: %d" %i
