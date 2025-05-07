extends CanvasLayer

const MemberScene = preload("res://examples/module2_nodes_and_scenes/M2_06_Groups_Example/group_member.tscn")

const DYNAMIC_GROUP_A = "dynamic_type_a" # 动态添加的组
const STATIC_GROUP_B = "static_type_b"   # 编辑器中设置的组

@onready var members_container: Control = $MembersContainer
@onready var status_label: Label = $ControlPanel/VBoxContainer/StatusLabel

var dynamic_member_counter = 0

func _ready():
	update_status_label()

# --- 按钮回调 ---
func _on_add_to_dynamic_a_button_pressed():
	dynamic_member_counter += 1
	var member_instance = MemberScene.instantiate()
	member_instance.name = "DynamicA_Member_" + str(dynamic_member_counter)
	# 随机放置在 MembersContainer 内
	var container_rect = members_container.get_rect() # 假设 MembersContainer 有一个定义区域
	member_instance.position = Vector2(randi_range(0, int(container_rect.size.x - 60)), randi_range(0, int(container_rect.size.y - 60)))
	
	members_container.add_child(member_instance)
	member_instance.add_to_group(DYNAMIC_GROUP_A)
	print("已将 '%s' 添加到分组 '%s'" % [member_instance.name, DYNAMIC_GROUP_A])
	update_status_label()

func _on_identify_dynamic_a_button_pressed():
	print("\n--- 识别动态分组 A (%s) ---" % DYNAMIC_GROUP_A)
	var members_in_group_a = get_tree().get_nodes_in_group(DYNAMIC_GROUP_A)
	if members_in_group_a.is_empty():
		print("分组 '%s' 中没有成员。" % DYNAMIC_GROUP_A)
	else:
		for member in members_in_group_a:
			if member.has_method("identify"):
				member.identify()
	update_status_label()

func _on_flash_dynamic_a_button_pressed():
	print("\n--- 闪烁动态分组 A (%s) ---" % DYNAMIC_GROUP_A)
	# 调用分组方法，传递红色
	get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFAULT, DYNAMIC_GROUP_A, "flash_color", Color.RED)
	update_status_label("已命令动态分组A闪烁红色")

func _on_identify_static_b_button_pressed():
	print("\n--- 识别静态分组 B (%s) ---" % STATIC_GROUP_B)
	var members_in_group_b = get_tree().get_nodes_in_group(STATIC_GROUP_B)
	if members_in_group_b.is_empty():
		print("分组 '%s' 中没有成员。请确保在编辑器中将一些GroupMember实例添加到了这个组。" % STATIC_GROUP_B)
	else:
		for member in members_in_group_b:
			if member.has_method("identify"):
				member.identify()
	update_status_label()
	
func _on_clear_dynamic_a_button_pressed():
	print("\n--- 清空动态分组 A (%s) ---" % DYNAMIC_GROUP_A)
	var members_to_clear = get_tree().get_nodes_in_group(DYNAMIC_GROUP_A)
	if members_to_clear.is_empty():
		print("分组 '%s' 已经是空的。" % DYNAMIC_GROUP_A)
	else:
		for member in members_to_clear:
			member.queue_free() # 这会触发成员的 _exit_tree
	
	# 等待一帧以确保 queue_free 完成
	await get_tree().process_frame 
	update_status_label("已清空动态分组A")

func _on_remove_from_group_button_pressed():
	var members_in_group_a = get_tree().get_nodes_in_group(DYNAMIC_GROUP_A)
	if !members_in_group_a.is_empty():
		var member_to_remove = members_in_group_a[0] # 移除第一个
		member_to_remove.remove_from_group(DYNAMIC_GROUP_A)
		print("已从分组 '%s' 中移除 '%s' (但未删除节点)。" % [DYNAMIC_GROUP_A, member_to_remove.name])
		if member_to_remove.has_method("identify"): # 让它自己报告一下
			member_to_remove.identify() 
		update_status_label("已从动态分组A中移除一个成员")
	else:
		print("动态分组 '%s' 中没有成员可以移除。" % DYNAMIC_GROUP_A)

# --- 辅助函数 ---
func update_status_label(message: String = ""):
	var count_a = get_tree().get_nodes_in_group(DYNAMIC_GROUP_A).size()
	var count_b = get_tree().get_nodes_in_group(STATIC_GROUP_B).size()
	var status_text = "动态分组A成员数: %s\n静态分组B成员数: %s" % [count_a, count_b]
	if !message.is_empty():
		status_text += "\n最新操作: " + message
	status_label.text = status_text
	print(status_text)
