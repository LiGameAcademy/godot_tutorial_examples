# simple_instance.gd
extends Node2D

@onready var label: Label = $Label

var flash_colors = [Color.WHITE, Color.YELLOW, Color.CYAN]
var current_color_index = 0
var rotation_speed = PI / 2 # 每秒旋转90度 (PI/2 弧度)

func _enter_tree():
	print(name + "._enter_tree() called")

func _ready():
	label.text = name + " (Ready)"
	print(name + "._ready() called")

func _process(delta: float):
	# 旋转节点
	rotation += rotation_speed * delta
	
	# 大约每秒更新两次标签文本，以显示节点正在处理
	# 避免过于频繁地更新标签导致性能问题或刷屏
	if Engine.get_frames_drawn() % 30 == 0: # 假设游戏以接近60FPS运行
		if get_tree() != null and not get_tree().paused: # 仅在未暂停时更新为 "Processing"
			label.text = name + " Processing (" + str(int(rad_to_deg(rotation)) % 360) + "°)"
		elif get_tree() != null and get_tree().paused:
			# 当暂停时，我们希望标签能反映这个状态
			# _process 本身在暂停时通常不被调用（除非 process_mode 设置为 always/when_paused）
			# 为了确保标签在暂停时能更新，这个逻辑可能需要一个信号或在父节点中处理
			# 但为了简单起见，如果它因为某些原因还是被调用了，就更新它
			label.text = name + " Paused" 
	
	# 如果希望在暂停时 _process 不被调用，标签内容会停留在 "Processing..."
	# 当恢复时，它会继续从那里更新。

func _physics_process(delta: float):
	# print(name + "._physics_process() called with delta: " + str(delta))
	pass
	
func _exit_tree():
	print(name + "._exit_tree() called")

func highlight_and_message(message: String):
	label.text = name + ": " + message
	modulate = Color.LIGHT_GREEN # 高亮节点本身
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.5).set_delay(0.5) # 半秒后恢复
	print(name + " received message: " + message)

func flash():
	current_color_index = (current_color_index + 1) % flash_colors.size()
	modulate = flash_colors[current_color_index]
	label.text = name + " flashed!"
	print(name + " flashed to " + str(modulate))
