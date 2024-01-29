extends PlayerAbilityState


func _on_hitbox_component_hit_gived_at(_pos: Vector2) -> void:
	Sfx2d.play_metal_sword_hit(SoundList.MetalSwordHit.METAL_LIGHT, _pos)
