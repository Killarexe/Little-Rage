extends Node

const SCREENSHOT_DIR: String = "user://screenshots/"

func _unhandled_input(event: InputEvent):
	if event is InputEventKey && OS.get_name() != "Web":
		if event.is_action_pressed("screenshot"):
			var image: Image = get_viewport().get_texture().get_image()
			if !DirAccess.dir_exists_absolute(SCREENSHOT_DIR):
				var create_dir_error: Error = DirAccess.make_dir_absolute(SCREENSHOT_DIR)
				if create_dir_error:
					print_rich("[color=red][b]Failed to create screenshot dir.\n\tError code: " + str(create_dir_error))
					return
			var current_date: Dictionary = Time.get_datetime_dict_from_system()
			var date_string: String = Time.get_datetime_string_from_datetime_dict(current_date, false)
			var file_path: String = SCREENSHOT_DIR + date_string + ".png"
			var save_error: Error = image.save_png(file_path)
			if save_error:
				print_rich(("[color=red][b]Failed to create screenshot file '%s'.\n\tError code: " % file_path) + str(save_error))
				return
			PopUpFrame.pop_translated("popup.screenshot")
			#TODO: add clipbord itegration(wait for Godot 4.3)
			#DisplayServer.clipboard_set("file://" + OS.get_user_data_dir() + "/screenshots/" + date_string + ".png")
			print_rich("[color=lightgreen][b]Successfuly created a screenshot. '%s'![/b][/color]" % file_path)
