extends Node2D

const SimpleInstanceScene = preload("res://examples/module2_nodes_and_scenes/M2_03_Scene_Tree_Example/simple_instance.tscn")
const DYNAMIC_INSTANCE_GROUP = "dynamic_instances"

@onready var instantiate_button: Button = $ControlPanel/ActionsVBox/InstantiateButton
@onready var remove_instance_button: Button = $ControlPanel/ActionsVBox/RemoveInstanceButton
@onready var call_group_button: Button = $ControlPanel/ActionsVBox/CallGroupButton
@onready var pause_button: Button = $ControlPanel/ActionsVBox/PauseButton
@onready var resume_button: Button = $ControlPanel/ActionsVBox/ResumeButton
@onready var instance_container: VBoxContainer = $InstanceContainer
@onready var log_display_label: Label = $ControlPanel/LogDisplayLabel

var instance_counter = 0
var last_instantiated_node: Node = null

# --- Lifecycle Demo ---
# We will create a node with a script specifically for demonstrating lifecycle methods.
# Let's define that script inline for simplicity in this example, or use simple_instance.gd

class LifecycleDemoScript extends Node:
	func _enter_tree():
		print("LifecycleDemoScript (%s): _enter_tree()" % name)
		get_parent().get_node("ControlPanel/LogDisplayLabel").text += "\nLifecycleDemoScript: _enter_tree()"
	func _ready():
		print("LifecycleDemoScript (%s): _ready()" % name)
		get_parent().get_node("ControlPanel/LogDisplayLabel").text += "\nLifecycleDemoScript: _ready()"
	func _process(delta):
		# print("LifecycleDemoScript (%s): _process()" % name) # Too spammy for label
		pass
	func _physics_process(delta):
		# print("LifecycleDemoScript (%s): _physics_process()" % name) # Too spammy for label
		pass
	func _exit_tree():
		print("LifecycleDemoScript (%s): _exit_tree()" % name)
		# Accessing parent's label here might be risky if parent is also queue_free'd at same time
		# So, just print to console for _exit_tree from this dynamic node.
		# get_parent().get_node("ControlPanel/LogDisplayLabel").text += "\nLifecycleDemoScript: _exit_tree()"


func _ready():
	log_display_label.text = "Scene Tree Demo Initialized.\nConsole has more detailed logs."
	print("--- SceneTreeDemo Main Ready ---")
	
	instantiate_button.pressed.connect(_on_InstantiateButton_pressed)
	remove_instance_button.pressed.connect(_on_RemoveInstanceButton_pressed)
	call_group_button.pressed.connect(_on_CallGroupButton_pressed)
	pause_button.pressed.connect(_on_PauseButton_pressed)
	resume_button.pressed.connect(_on_ResumeButton_pressed)

	# Add a node for lifecycle demo
	var lifecycle_node = Node.new()
	lifecycle_node.name = "LifecycleDemoInstance"
	var lifecycle_script = LifecycleDemoScript.new() # Create instance of the inner class
	lifecycle_node.set_script(lifecycle_script)
	add_child(lifecycle_node) # Add to scene tree to trigger its lifecycle

	print_current_scene_tree_structure()


func _on_InstantiateButton_pressed():
	instance_counter += 1
	var new_instance = SimpleInstanceScene.instantiate()
	new_instance.name = "MyInstance_" + str(instance_counter)
	# Position it within the container - simple vertical stacking
	new_instance.position = Vector2(20, instance_container.get_child_count() * 60) # Adjust spacing as needed
	
	instance_container.add_child(new_instance)
	new_instance.add_to_group(DYNAMIC_INSTANCE_GROUP)
	last_instantiated_node = new_instance
	
	log_display_label.text = new_instance.name + " instantiated and added to group '" + DYNAMIC_INSTANCE_GROUP + "'."
	print(new_instance.name + " instantiated.")
	print_current_scene_tree_structure()
	new_instance.call("highlight_and_message", "I'm newly instantiated!")


func _on_RemoveInstanceButton_pressed():
	var children = instance_container.get_children()
	if children.size() > 0:
		var node_to_remove = children[children.size() -1] # Get the last one added to container
		node_to_remove.remove_from_group(DYNAMIC_INSTANCE_GROUP)
		# node_to_remove.get_parent().remove_child(node_to_remove) # This is done by queue_free
		node_to_remove.queue_free() # This also handles _exit_tree() and removes from parent
		
		log_display_label.text = node_to_remove.name + " removed and freed."
		print(node_to_remove.name + " requested to be freed.")
		if node_to_remove == last_instantiated_node:
			last_instantiated_node = null
		print_current_scene_tree_structure()
	else:
		log_display_label.text = "No instances to remove from container."
		print("No instances to remove.")

func _on_CallGroupButton_pressed():
	log_display_label.text = "Calling 'flash()' on group: " + DYNAMIC_INSTANCE_GROUP
	print("Calling 'flash()' on group: " + DYNAMIC_INSTANCE_GROUP)
	# Ensure the method exists and is safe to call
	get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFAULT, DYNAMIC_INSTANCE_GROUP, "flash")


func _on_PauseButton_pressed():
	get_tree().paused = true
	log_display_label.text = "SceneTree Paused. (UI might still respond if process mode is 'always')"
	print("SceneTree Paused.")
	# Note: UI elements might still work if their process mode is set to "Always"

func _on_ResumeButton_pressed():
	get_tree().paused = false
	log_display_label.text = "SceneTree Resumed."
	print("SceneTree Resumed.")

func print_current_scene_tree_structure():
	print("\n--- Current Scene Tree (Abbreviated) ---")
	_print_node_recursive(get_tree().current_scene, 0)
	print("---------------------------------------\n")

func _print_node_recursive(node: Node, indent_level: int):
	if node == null:
		return
	var indent_str = "  ".repeat(indent_level)
	print(indent_str + "- " + node.name + " (" + node.get_class() + ")")
	for child in node.get_children():
		_print_node_recursive(child, indent_level + 1)
