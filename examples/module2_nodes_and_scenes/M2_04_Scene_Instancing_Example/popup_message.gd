extends PanelContainer

@onready var label: Label = $MarginContainer/Label
var lifetime_timer: Timer

func _ready():
	# Make the popup disappear after a few seconds
	lifetime_timer = Timer.new()
	lifetime_timer.wait_time = 3.0
	lifetime_timer.one_shot = true
	lifetime_timer.timeout.connect(queue_free) # Signal to remove itself
	add_child(lifetime_timer)
	lifetime_timer.start()
	
	print("PopupMessage '%s' ready, will self-destruct." % name)

func set_message(message: String):
	label.text = message

func _exit_tree():
	print("PopupMessage '%s' is being freed." % name)