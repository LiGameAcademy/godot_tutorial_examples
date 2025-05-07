extends Node2D

@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label

func _ready():
	label.text = name # Set label to node's name for easy identification
	print("成员 '%s' 已准备就绪。所属分组: %s" % [name, get_groups()])

func identify():
	var groups_string = "，".join(get_groups())
	if groups_string.is_empty():
		groups_string = "无"
	print("你好！我是 '%s'。我所在的分组有: [%s]" % [name, groups_string])
	label.text = "%s\nGroups: %s" % [name, groups_string]

func flash_color(target_color: Color):
	var original_color = color_rect.color
	color_rect.color = target_color
	print("成员 '%s' 闪烁颜色为: %s" % [name, target_color])
	
	var tween = create_tween()
	tween.tween_property(color_rect, "color", original_color, 0.7).set_delay(0.3)

func _exit_tree() -> void:
	print("成员 '%s' 正在被释放并移出场景树。" % name)
