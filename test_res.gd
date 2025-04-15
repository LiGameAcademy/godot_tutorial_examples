extends Resource
class_name TestRes

var i : int = 1

func _to_string() -> String:
	return "test_res: %d" %i
