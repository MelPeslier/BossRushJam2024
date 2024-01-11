extends PlayerState

#@export var soul_scene: PackedScene
@export var ability_input_component: AbilityInputComponent

func enter() -> void:
	super()
	ability_input_component.disable_attack()
	player.disable_input()
	GameState.player_died()


func spawn_soul() -> void:
	pass
	#var soul_instance = soul_scene.instantiate()
	#get_window().add_child(soul_instance)
	#soul_instance.global_position = parent.global_position
	#soul_instance.init()


func back() -> void:
	SceneTransition.change_scene("res://ui/menus/menu.tscn")
