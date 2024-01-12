class_name Altar
extends Node2D

@export var spawn_marker: Marker2D
@export var _show_commands: MyCheckBox
@export var sprite: Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var interactable_collision_shape: CollisionShape2D
@onready var altar_menu: CanvasLayer = $AltarMenu

@export_group("Altar", "altar_")
@export var altar_disappear_offset: float = 300
@export var altar_disappear_duration: float = 2.0
@export var altar_strength_start: float = 20
@export var altar_fade_start: float = 1
@export var altar_fade_stop: float = 4
@export_group("Boss", "boss_")
@export var boss_1_packed: PackedScene


func _ready() -> void:
	var _toggled_on := GameState.saved_game.show_commands
	_show_commands.set_pressed_no_signal(_toggled_on)
	GameEvents.toggle_tutorial.emit(_toggled_on)



func _on_interactable_component_focused(_interactor: InteractorComponent) -> void:
	print("altar focus")

func _on_interactable_component_interacted(_interactor: InteractorComponent) -> void:
	animation_player.play("show_menu")
	GameEvents.menu_opened.emit()
	Parameters.ui_elements.push_back(self)

func _on_interactable_component_unfocused(_interactor: InteractorComponent) -> void:
	if altar_menu.visible:
		_on_back_button_down()


func process_unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("back"):
		_on_back_button_down()



func _on_be_a_true_challenger_toggled(toggled_on: bool) -> void:
	GameEvents.true_challenger.emit(toggled_on)

func _on_challenge_boss_1_button_down() -> void:
	challenge_boss(boss_1_packed)

func challenge_boss(_ps: PackedScene) -> void:
	GameEvents.boss_killed.connect( _on_boss_killed, CONNECT_ONE_SHOT )
	interactable_collision_shape.disabled = true

	GameState.in_cinematic = true
	_on_back_button_down()
	GameEvents.toggle_tutorial.emit(false)
	GameEvents.screen_shake.emit(altar_strength_start, altar_fade_start)
	# Hide Altar
	var t: Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "position:y", altar_disappear_offset, altar_disappear_duration)
	t.tween_callback(_stop_screen_shake)

	# Spawn Boss in Air and make it fall to the ground (animation where the player can't move)
	var instance = _ps.instantiate() as Node2D
	instance.global_position = spawn_marker.global_position
	t.tween_callback( add_sibling.bind(instance) )


func _on_boss_killed() -> void:
	# Show Altar
	var t: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.tween_property(self, "position:y", 0, altar_disappear_duration)
	t.tween_callback(_stop_screen_shake)
	t.tween_interval(1)
	t.tween_property(interactable_collision_shape, "disabled", false, 0)


func _stop_screen_shake() -> void:
	GameEvents.screen_shake.emit(altar_strength_start - altar_fade_start * altar_disappear_duration, altar_fade_stop)

func _on_show_commands_toggled(toggled_on: bool) -> void:
	GameEvents.toggle_tutorial.emit(toggled_on)
	GameState.saved_game.show_commands = toggled_on
	GameState.save_game()


func _on_back_button_down() -> void:
	Parameters.ui_elements.pop_back()
	animation_player.play("hide_menu")
	var timer := Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(0.1)
	await timer.timeout
	timer.queue_free()
	GameEvents.menu_closed.emit()


