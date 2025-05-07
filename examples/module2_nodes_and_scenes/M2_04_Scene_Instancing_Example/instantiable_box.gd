extends Node2D

func _ready():
	set_meta("is_instanced_box", true)
	print(name + " (InstantiableBox) is ready.")
	if has_node("ColorRect/Label"):
		$ColorRect/Label.text = name # Set initial text to its own name for uniqueness

func interact():
	print(name + " was interacted with!")
	var new_color = Color(randf(), randf(), randf())
	if has_node("ColorRect"):
		$ColorRect.color = new_color

func change_color_and_text(new_color: Color, new_text: String) -> void:
	if has_node("ColorRect"):
		$ColorRect.color = new_color
		if $ColorRect.has_node("Label"):
			$ColorRect/Label.text = new_text
	print(name + " color changed to " + str(new_color) + " and text to '" + new_text + "'.")

func _exit_tree() -> void:
	print(name + " (InstantiableBox) is being freed.")
