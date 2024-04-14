class_name DataLoader

func load_data_in_dir(dir_path: String, type: String) -> Array[ResourceElement]:
	print_rich("[b]Registering %s:[/b]" % type)
	var result: Array[ResourceElement] = []
	var id_array: Array[String] = []
	var dir: DirAccess = DirAccess.open(dir_path)
	if !dir:
		print_rich("[color=red][b]\tFailed to read dir '%s'[/b][/color]" % dir_path)
		return result
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		file = file.replace(".remap", "")
		var is_tres: bool = file.ends_with(".tres")
		if file == "":
			break
		if is_tres:
			var resource: Resource = load(dir_path + "/" + file)
			if resource is ResourceElement:
				var id: String = file.split(".")[0]
				if id_array.has(id):
					print_rich("[color=yellow][b]Resource element conflict: Two " + type + " with the same id '" + resource.id + "'[/b][/color]")
					PopUpFrame.pop(TranslationServer.translate("popup.resource_element_confict") % [type, resource.id])
				else:
					print_rich("[color=green][i]\t%s loaded.[/i][/color]" % id)
					resource.id = id
					id_array.append(id)
					result.append(resource)
	return result
