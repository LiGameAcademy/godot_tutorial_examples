extends CanvasLayer

@onready var label : Label = $Label

@export var rotation_speed : float = 10

func _process(delta):
	#每帧更新旋转角度
	label.rotation += rotation_speed * delta

	# 实现文字颜色渐变
	var color = label.get_theme_color("font_color")
	color.r = sin(Time.get_ticks_msec() / 1000.0) * 0.5 + 0.5
	color.g = sin(Time.get_ticks_msec() / 1000.0 + 2.0) * 0.5 + 0.5
	color.b = sin(Time.get_ticks_msec() / 1000.0 + 4.0) * 0.5 + 0.5
	label.add_theme_color_override("font_color", color)
