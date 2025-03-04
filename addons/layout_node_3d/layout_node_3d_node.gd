@tool
extends Node3D
class_name LayoutNode3D

var isLayoutNode3D = true

func align_children(spacing: float, axis: String) -> void:
	var distance = 0.0
	var children = get_children()
	
	for child in children:
		if not child is Node3D:
			continue
		
		var size = get_node_size(child)
		var scaled_size = size * child.scale
		
		match axis:
			"x":
				child.position = Vector3(distance, 0, 0)
				distance += scaled_size.x + spacing
			"y":
				child.position = Vector3(0, distance, 0)
				distance += scaled_size.y + spacing
			"z":
				child.position = Vector3(0, 0, distance)
				distance += scaled_size.z + spacing

func get_node_size(node: Node3D) -> Vector3:
	if node is MeshInstance3D and node.mesh:
		return node.mesh.get_aabb().size
	elif node is CollisionShape3D and node.shape:
		return node.shape.get_debug_mesh().get_aabb().size
	else:
		var aabb = AABB()
		for child in node.get_children():
			if child is Node3D:
				var child_aabb = get_node_aabb(child)
				aabb = aabb.merge(child_aabb)
		return aabb.size

func get_node_aabb(node: Node3D) -> AABB:
	if node is MeshInstance3D and node.mesh:
		return node.mesh.get_aabb()
	elif node is CollisionShape3D and node.shape:
		return node.shape.get_debug_mesh().get_aabb()
	else:
		var aabb = AABB()
		for child in node.get_children():
			if child is Node3D:
				var child_aabb = get_node_aabb(child)
				child_aabb = child_aabb.grow(child.position.length())
				aabb = aabb.merge(child_aabb)
		return aabb
