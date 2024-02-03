extends MusicPlayer

@export var my_camera_spot: MyCameraSpot

func _ready() -> void:
	my_camera_spot.player_entered.connect( _on_my_camera_spot_player_entered )
	my_camera_spot.player_exited.connect( _on_my_camera_spot_player_exited )

func _on_my_camera_spot_player_entered(_player: Player) -> void:
	play()


func _on_my_camera_spot_player_exited(_player: Player) -> void:
	pass # Replace with function body.
