extends PlayerState

@export var ability_input_component: AbilityInputComponent
@export var shocwave_sound: AudioStreamPlayer

func enter() -> void:
	super()
	ability_input_component.disable_attack()
	move_data.disable_move()
	player.hurtbox_component.deactivate()
	GameEvents.player_died.emit( parent.global_position )


func play_stream() -> void:
	Sfx._play(shocwave_sound)
	Music.fade_sounds(Music.Fade.OUT)


func restart() -> void:
	SceneTransition.reload_current_scene()
