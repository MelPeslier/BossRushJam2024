@tool
class_name MyButton
extends Button

static var min_size := Vector2(200, 60)
static var buttons: Array[MyButton] = []

@export var apply: bool : set = _set_apply


func _init() -> void:
	buttons.append(self)
	custom_minimum_size = min_size


func _ready() -> void:
	pass


static func _update_min_size() -> void:
	for button: MyButton in buttons:
		button.custom_minimum_size = min_size


func _set_apply(_do: bool) -> void:
	min_size = custom_minimum_size
	MyButton._update_min_size()


func _exit_tree() -> void:
	buttons.erase(self)

