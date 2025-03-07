extends EditorInspectorPlugin

var spacing_input: SpinBox
var axis_control: HBoxContainer

func _parse_begin(object):
	# Create a VBoxContainer to hold all custom controls
	var container = VBoxContainer.new()

	# Add spacing input (horizontal layout)
	var spacing_container = HBoxContainer.new()
	container.add_child(spacing_container)

	var spacing_label = Label.new()
	spacing_label.text = "Spacing"
	spacing_container.add_child(spacing_label)

	# Add a spacer to push the input to the right
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spacing_container.add_child(spacer)
	
	var inputs = get_inputs(object)

	spacing_input = SpinBox.new()
	spacing_input.min_value = 0.0
	spacing_input.max_value = 100.0
	spacing_input.step = 0.1
	spacing_input.value = inputs.spacing
	spacing_input.value_changed.connect(_on_spacing_changed.bind(object))
	spacing_container.add_child(spacing_input)

	# Add axis selection (horizontal layout)
	var axis_container = HBoxContainer.new()
	container.add_child(axis_container)
	var axis_label = Label.new()
	axis_label.text = "Axis"
	axis_container.add_child(axis_label)

	# Add a spacer to push the axis control to the right
	spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	axis_container.add_child(spacer)

	axis_control = HBoxContainer.new()
	axis_container.add_child(axis_control)
	
	var x_button = Button.new()
	x_button.text = "X"
	x_button.toggle_mode = true
	x_button.set_pressed_no_signal(inputs.axis == "x")
	x_button.pressed.connect(_on_axis_button_pressed.bind("x", object))

	var y_button = Button.new()
	y_button.text = "Y"
	y_button.toggle_mode = true
	y_button.set_pressed_no_signal(inputs.axis == "y")
	y_button.pressed.connect(_on_axis_button_pressed.bind("y", object))

	var z_button = Button.new()
	z_button.text = "Z"
	z_button.toggle_mode = true
	z_button.set_pressed_no_signal(inputs.axis == "z")
	z_button.pressed.connect(_on_axis_button_pressed.bind("z", object))

	axis_control.add_child(x_button)
	axis_control.add_child(y_button)
	axis_control.add_child(z_button)

	# Add align button
	var button = Button.new()
	button.text = "Align Child Nodes"
	button.scale = Vector2(2, 1)
	button.pressed.connect(_on_align_button_pressed.bind(object))
	container.add_child(button)

	# Finalize and inject the container into the inspector
	add_custom_control(container)

func _on_spacing_changed(value, object):
	object.set_meta("spacing", value)

func _on_align_button_pressed(layout_node_3d):
	# Pass user-defined values to the align_children function.
	var inputs = get_inputs(layout_node_3d)
	layout_node_3d.align_children(inputs.spacing, inputs.axis)

func _on_axis_button_pressed(selected_axis: String, object):
	# Ensure only one button is active at a time.
	for child in axis_control.get_children():
		if child is Button:
			child.button_pressed = (child.text.to_lower() == selected_axis)
	
	object.set_meta("axis", selected_axis)

# Ensure this plugin only applies to LayoutNode3D nodes.
func _can_handle(node):
	return node is LayoutNode3D

# Get input values with defaults.
func get_inputs(node):
	var spacing = node.get_meta('spacing', 1.0)
	var axis = node.get_meta('axis', 'x')
	return { "spacing": spacing, "axis": axis.to_lower() }
