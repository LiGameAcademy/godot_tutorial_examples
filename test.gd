extends CanvasLayer

const TEST_RES = preload("res://test_res.tres")
const TEST_OBJ = preload("res://test_obj.tscn")
@export var test_res: TestRes 
@export var test_res_2: TestRes

func _ready() -> void:
	_test_ref()
	print("============================")
	_test_res()
	print("============================")
	_test_obj()
	print("============================")
	_test_array()
	
func _test_ref() -> void:
	var test_ref : TestRef = TestRef.new()
	var test_ref_2 : TestRef = test_ref.duplicate()
	test_ref_2.i = 2
	print(test_ref_2)
	print(test_ref)
	
func _test_res() -> void:
	#test_res_2 = test_res_2.duplicate()
	test_res_2.i = 2
	print(test_res_2)
	print(test_res)

func _test_array() -> void:
	test_res.resource_local_to_scene = true
	var test_array : Array = [test_res]
	var test_array_2 : Array = test_array.duplicate(true)
	test_array_2[0].i = 3
	print(test_array)
	print(test_array_2)

func _test_obj() -> void:
	var test_obj : TestObj = preload("res://test_obj.tscn").instantiate()
	var test_obj_2 : TestObj = TEST_OBJ.instantiate()
	test_obj_2.i = 2
	print(test_obj)
	print(test_obj_2)
