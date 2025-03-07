@tool
extends EditorPlugin

const pluginIconPath = "res://addons/layout_node_3d/icon.png"
const layoutNode3dPath = "res://addons/layout_node_3d/layout_node_3d_node.gd"
const inspectorPluginPath = "res://addons/layout_node_3d/layout_node_3d_inspector.gd"

var inspectorPlugin
var pluginScript
var pluginIcon

func _enter_tree() -> void:
	inspectorPlugin = preload(inspectorPluginPath).new()
	pluginScript = preload(layoutNode3dPath)
	pluginIcon = preload(pluginIconPath)
	add_custom_type("LayoutNode3D", "Node3D", pluginScript, pluginIcon)
	add_inspector_plugin(inspectorPlugin)

func _exit_tree() -> void:
	remove_custom_type("LayoutNode3D")
	remove_inspector_plugin(inspectorPlugin)
