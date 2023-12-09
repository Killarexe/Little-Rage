extends Node

const SCREENSHOT_DIR: String = "user://screenshots/"

func _unhandled_input(event: InputEvent):
	if event is InputEventKey:
		if event.is_action_pressed("screenshot"):
			var image: Image = get_viewport().get_texture().get_image()
			if !DirAccess.dir_exists_absolute(SCREENSHOT_DIR):
				var create_dir_error: Error = DirAccess.make_dir_absolute(SCREENSHOT_DIR)
				if create_dir_error:
					print_debug("Failed to create screenshot dir. Error code: " + str(create_dir_error))
					return
			var current_date: Dictionary = Time.get_datetime_dict_from_system()
			var date_string: String = Time.get_datetime_string_from_datetime_dict(current_date, false)
			var file_path: String = SCREENSHOT_DIR + date_string + ".png"
			var save_error: Error = image.save_png(file_path)
			if save_error:
				print_debug(("Failed to create screenshot file '%s'. Error code: " % file_path) + str(save_error))
				return
			print_debug("Successfuly create screenshot. '%s'!" % file_path)
