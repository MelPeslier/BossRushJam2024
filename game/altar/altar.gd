class_name Altar
extends Node2D



func _on_interactable_component_focused(_interactor: InteractorComponent) -> void:
	print("focus")


func _on_interactable_component_interacted(_interactor: InteractorComponent) -> void:
	print("interact")


func _on_interactable_component_unfocused(_interactor: InteractorComponent) -> void:
	print("unfocus")
