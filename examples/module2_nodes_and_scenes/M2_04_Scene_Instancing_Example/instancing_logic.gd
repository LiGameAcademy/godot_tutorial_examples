extends Node2D

const BoxScene = preload("res://examples/module2_nodes_and_scenes/M2_04_Scene_Instancing_Example/instantiable_box.tscn")
const PopupScene = preload("res://examples/module2_nodes_and_scenes/M2_04_Scene_Instancing_Example/popup_message.tscn")

@onready var instance_count_label: Label = $VBoxContainer/InstanceCountLabel
@onready var modify_last_button: Button = $VBoxContainer/ModifyLastButton
@onready var show_popup_button: Button = $VBoxContainer/ShowPopupButton # Added

var created_instances_count = 0
var last_instance_node: Node2D = null # To keep track of the last box instance

func _ready():
	update_instance_count_label()
	# Connections are done in the scene file for existing buttons
	# Connect new buttons
	modify_last_button.pressed.connect(_on_ModifyLastButton_pressed)
	show_popup_button.pressed.connect(_on_ShowPopupButton_pressed) # Added

func _on_InstanceButton_pressed():
	if BoxScene:
		var box_instance = BoxScene.instantiate()
		if box_instance is Node2D: # Check type for safety
			var random_x = randi_range(50, int(get_viewport_rect().size.x) - 100)
			var random_y = randi_range(150, int(get_viewport_rect().size.y) - 100)
			box_instance.position = Vector2(random_x, random_y)
			box_instance.name = "BoxInstance_" + str(created_instances_count)
			
			add_child(box_instance)
			last_instance_node = box_instance # Update last instance
			created_instances_count += 1
			update_instance_count_label()
			print("Instantiated '%s' at: %s" % [box_instance.name, box_instance.position])
		else:
			push_error("Failed to instantiate BoxScene or it's not a Node2D!")
	else:
		push_error("BoxScene is not loaded!")

func update_instance_count_label():
	instance_count_label.text = "Box Instances: " + str(get_box_instance_count())

func get_box_instance_count() -> int:
	var count = 0
	for child in get_children():
		if child.has_meta("is_instanced_box") and child.get_meta("is_instanced_box") == true:
			count += 1
	return count

func _on_ClearInstancesButton_pressed():
	var boxes_to_remove = []
	for child in get_children():
		if child.has_meta("is_instanced_box") and child.get_meta("is_instanced_box") == true:
			boxes_to_remove.append(child)
	
	for box in boxes_to_remove:
		print("Queueing free for: " + box.name)
		box.queue_free()

	# Update count after a short delay to allow queue_free to process
	await get_tree().create_timer(0.1).timeout 
	created_instances_count = get_box_instance_count() # Recount actual instances
	if created_instances_count == 0:
		last_instance_node = null # Reset if all are cleared
	update_instance_count_label()
	print("Cleared instanced boxes.")

func _on_ModifyLastButton_pressed():
	if is_instance_valid(last_instance_node) and last_instance_node.has_method("change_color_and_text"):
		var random_hue = randf()
		var new_color = Color.from_hsv(random_hue, 0.8, 0.9)
		last_instance_node.change_color_and_text(new_color, "MODIFIED!")
		print("Called change_color_and_text on " + last_instance_node.name)
	else:
		print("No valid last instance to modify or method not found.")

func _on_ShowPopupButton_pressed(): # Added
	if PopupScene:
		var popup_instance = PopupScene.instantiate()
		if popup_instance:
			popup_instance.name = "MyPopupMessage_" + str(randi_range(0,999))
			# Position it (e.g., center of screen, or near the button)
			# For simplicity, let's add it as a direct child. It will position itself based on its anchors.
			add_child(popup_instance) 
			if popup_instance.has_method("set_message"):
				popup_instance.set_message("Hello from Instancing Demo!")
			print("Popup message '%s' instantiated." % popup_instance.name)
		else:
			push_error("Failed to instantiate PopupScene!")
	else:
		push_error("PopupScene not loaded!")
