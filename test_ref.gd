extends RefCounted
class_name TestRef

var i : int = 1

func duplicate() -> TestRef:
	var test_ref = TestRef.new()
	test_ref.i = i
	return test_ref

func _to_string() -> String:
	return "test_ref: %d" %i
