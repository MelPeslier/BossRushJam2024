extends CharacterBody2D

@export var need_dir: Array[Node2D]
@export var aggro_time: float = 3

@onready var state_machine: StateMachine = $StateMachine
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var move_input_component: Node = $MoveInputComponent
@onready var move_data: MoveData = $MoveData
@onready var terrain_detector: TerrainDetector = $TerrainDetector


var target: Node2D
var losing_aggro := false
var aggro_timer: float = 0


func _ready() -> void:
	state_machine.init(self, animator, animated_sprite, move_input_component, move_data)
	move_data.dir = -move_data.dir
	move_data.dir = -move_data.dir


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_unhandled_input(event)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func _process(delta: float) -> void:
	if losing_aggro:
		aggro_timer -= delta
		if aggro_timer <= 0:
			target = null
			losing_aggro = false
	state_machine.process_frame(delta)


func _on_move_data_dir_changed(new_dir: float) -> void:
	for node: Node2D in need_dir:
		node.scale.x = - new_dir * abs( node.scale.x )


func _on_detector_body_entered(body: Node2D) -> void:
	if not body is Player: return
	target = body
	losing_aggro = false


func _on_detector_body_exited(body: Node2D) -> void:
	if not body is Player: return
	losing_aggro = true
	aggro_timer = aggro_time
