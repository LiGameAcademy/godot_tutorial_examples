extends Label

# 这个方法将通过编辑器连接到 EmitterButton 的自定义信号
func on_editor_connected_event(received_message: String, event_id: int):
	var text_to_display = "编辑器连接事件:\n消息: %s\n事件ID: %s" % [received_message, event_id]
	print("接收器 (编辑器连接): 信号收到 - %s" % text_to_display)
	self.text = text_to_display
	self.modulate = Color.LIGHT_GREEN # 给点视觉反馈

# 这个方法将通过代码连接到 CodeConnectedButton 的自定义信号
func on_code_connected_event(received_message: String, event_id: int):
	var text_to_display = "代码连接事件:\n消息: %s\n事件ID: %s" % [received_message, event_id]
	print("接收器 (代码连接): 信号收到 - %s" % text_to_display)
	self.text = text_to_display
	self.modulate = Color.LIGHT_BLUE # 给点不同的视觉反馈

func _ready():
	self.text = "等待信号..."
	self.vertical_alignment = VERTICAL_ALIGNMENT_TOP # 确保多行文本可见
	self.autowrap_mode = TextServer.AUTOWRAP_WORD
