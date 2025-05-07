extends Node2D

# 确保路径正确指向你的节点
@onready var code_connected_button: Button = $ButtonContainer/CodeConnectedButton
@onready var receiver_label: Label = $ReceiverLabel
@onready var lambda_button: Button = $ButtonContainer/LambdaButton # 新增Lambda演示按钮
@onready var lambda_info_label: Label = $LambdaInfoLabel # 新增Lambda演示标签


func _ready():
	# 1. 通过代码连接 CodeConnectedButton 的自定义信号
	if code_connected_button and code_connected_button.has_signal("button_event_fired"):
		# 注意：Callable 的第一个参数是目标对象，第二个是方法名
		var callable_for_code_connection = Callable(receiver_label, "on_code_connected_event")
		code_connected_button.button_event_fired.connect(callable_for_code_connection)
		print("signals_demo.gd: 已通过代码连接 'CodeConnectedButton' 的 'button_event_fired' 信号到 'ReceiverLabel.on_code_connected_event'")
	else:
		printerr("signals_demo.gd: 无法找到 CodeConnectedButton 或其 'button_event_fired' 信号。")

	# 2. 演示使用 Lambda 表达式连接信号 (Godot 4)
	if lambda_button:
		lambda_button.pressed.connect(func(): 
			var lambda_msg = "Lambda按钮被按下了！时间: " + str(Time.get_time_string_from_system())
			print(lambda_msg)
			if lambda_info_label:
				lambda_info_label.text = lambda_msg
		)
		print("signals_demo.gd: 已通过代码和Lambda表达式连接 'LambdaButton' 的 'pressed' 信号。")
	else:
		printerr("signals_demo.gd: 无法找到 LambdaButton。")
