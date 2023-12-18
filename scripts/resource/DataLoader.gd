class_name DataLoader

func load_data_in_dir(dir_path: String, type: String) -> Array[ResourceElement]:
	print("Registering %s: " % type)
	var result: Array[ResourceElement] = []
	var id_array: Array[String] = []
	var dir: DirAccess = DirAccess.open(dir_path)
	if !dir:
		print("\tFailed to read dir '%s'" % dir_path)
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
					print("Resource element conflict: Two " + type + " with the same id '" + resource.id + "'")
					PopUpFrame.pop(TranslationServer.translate("popup.resource_element_confict") % [type, resource.id])
				else:
					print("\t%s loaded." % id)
					resource.id = id
					id_array.append(id)
					result.append(resource)
	return result
