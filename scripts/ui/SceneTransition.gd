extends CanvasLayer

func change_scene_to_file(target: String) -> void:
	print("Dissolve...")
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	print("Changing...")
	get_tree().change_scene_to_file(target)
	print("Changed!")
	$AnimationPlayer.play_backwards("dissolve")
