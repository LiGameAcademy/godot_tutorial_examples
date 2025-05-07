extends Node2D

# 预加载我们的组件场景
const SimpleComponentScene = preload("res://examples/module2_nodes_and_scenes/M2_01_Nodes_as_Scenes_Example/simple_component.tscn")

func _ready():
	print(self.name + " is ready. Now instantiating child components.")

	# 实例化第一个组件
	var component1 = SimpleComponentScene.instantiate()
	component1.name = "ComponentInstance1" # 给实例一个独特的名字
	component1.position = Vector2(100, 150)
	# 你可以直接设置导出变量
	component1.component_color = Color.RED 
	add_child(component1)

	# 实例化第二个组件
	var component2 = SimpleComponentScene.instantiate()
	component2.name = "ComponentInstance2"
	component2.position = Vector2(300, 150)
	# 或者通过调用方法来修改
	component2.call("highlight", Color.GREEN_YELLOW) # 假设 simple_component.gd 有 highlight 方法
	add_child(component2)
	
	# 实例化第三个组件，并设置不同的初始颜色
	var component3 = SimpleComponentScene.instantiate()
	component3.name = "ComponentInstance3"
	component3.position = Vector2(500, 150)
	component3.component_color = Color.DODGER_BLUE 
	# _ready() 将会使用这个 component_color
	add_child(component3)
	
	# 你也可以在之后调用组件的方法
	# 例如，让第一个组件高亮
	if component1:
		component1.highlight(Color.GOLD)

	var label = get_node_or_null("Label")
	if label:
		label.text = "This scene now instantiates multiple 'SimpleComponent' scenes. Check output for logs."
