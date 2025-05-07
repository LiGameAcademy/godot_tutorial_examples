# simple_component.gd
extends Node2D

# 导出一个颜色变量，方便在检查器中或代码中设置
@export var component_color : Color = Color.WHITE

func _ready():
	# 获取子节点 Sprite2D
	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		sprite.modulate = component_color
		print(name + " is ready and color set to: " + str(component_color))
	else:
		print(name + " is ready, but Sprite2D node not found!")

func highlight(new_color: Color):
	var sprite = get_node_or_null("Sprite2D")
	if sprite:
		sprite.modulate = new_color
		print(name + " highlight color changed to: " + str(new_color))
