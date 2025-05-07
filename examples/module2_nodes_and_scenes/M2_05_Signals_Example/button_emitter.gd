extends Button

# 自定义信号，现在带有两个参数
signal button_event_fired(message: String, click_id: int)

var internal_click_counter = 0

func _ready():
	# 将内置的 "pressed" 信号连接到我们自己的方法
	# 这样，当这个按钮被按下时，会先执行 _on_this_button_pressed
	self.pressed.connect(_on_this_button_pressed)
	self.text = self.name # 给按钮设置一个默认文本，方便区分

func _on_this_button_pressed():
	internal_click_counter += 1
	var event_message = "按钮 '%s' 被按下了 %s 次." % [self.name, internal_click_counter]
	var unique_event_id = randi_range(1000, 9999) # 模拟一个唯一的事件ID
	
	print("发射器 (%s): 发射信号 - 消息: '%s', ID: %s" % [self.name, event_message, unique_event_id])
	# 发射我们的自定义信号
	button_event_fired.emit(event_message, unique_event_id)
