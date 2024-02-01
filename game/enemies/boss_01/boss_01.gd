extends CharacterBody2D

@export var need_dir: Array[Node2D]

@onready var state_machine: StateMachine = $StateMachine
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var move_input_component: Node = $MoveInputComponent
@onready var move_data: MoveData = $MoveData
@onready var terrain_detector: TerrainDetector = $TerrainDetector
@onready var health_component: HealthComponent = $HealthComponent
@onready var hit: Node = $StateMachine/get_hit
@onready var die: Node = $StateMachine/dead



var target: Node2D
