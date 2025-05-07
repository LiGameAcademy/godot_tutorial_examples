extends Node2D

@onready var label_node: Label = $VBoxContainer/InfoLabel
@onready var button_node: Button = $VBoxContainer/TestButton
@onready var timer_node: Timer = $TestTimer
@onready var animated_sprite_node: AnimatedSprite2D = $AnimatedSpriteExample
@onready var ball_node: RigidBody2D = $Ball
@onready var sound_player_node: AudioStreamPlayer2D = $SoundPlayer

func _ready():
	label_node.text = "常见节点演示。\n按下按钮使球跳起并播放声音！"
	button_node.pressed.connect(_on_TestButton_pressed)
	
	animated_sprite_node.play("default") # 确保SpriteFrames中有 "default" 动画
	print("CommonNodesDemo (改写版) ready.")

func _on_TestButton_pressed():
	label_node.text = "按钮按下！小球受到向上的力。"
	print("按钮按下。")

	# 给球一个向上的冲量
	ball_node.apply_central_impulse(Vector2(0, -200)) # 调整冲量大小以获得期望的效果

	# 播放声音
	if sound_player_node.stream:
		sound_player_node.play()
	else:
		label_node.text += "\n(音效未播放，请检查配置)"
		push_warning("无法播放音效，stream 未设置。")

	# 简单的计时器示例，例如让按钮在短时间内禁用
	button_node.disabled = true
	timer_node.start()

func _on_TestTimer_timeout():
	label_node.text = "计时器结束！按钮已激活。"
	button_node.disabled = false
	print("计时器超时。")

func _physics_process(_delta: float) -> void:
	# 可以在这里添加一些基于物理的逻辑，如果需要的话
	# 例如，如果球掉出屏幕，重置它的位置
	if ball_node.position.y > get_viewport_rect().size.y + 50: # 50 是一个缓冲值
		ball_node.linear_velocity = Vector2.ZERO
		ball_node.angular_velocity = 0.0
		ball_node.position = Vector2(get_viewport_rect().size.x / 2, 100) # 重置到屏幕中间靠上的位置
		label_node.text += "\n(小球掉出屏幕，已重置)"
