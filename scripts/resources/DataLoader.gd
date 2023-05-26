class_name DataLoader

func load_data_in_dir(dir_path: String, type: String) -> Array[ResourceElement]:
	var result: Array[ResourceElement] = []
	var dir: DirAccess = DirAccess.open(dir_path)
	if !dir:
		print("Failed to read dir '%s'" % dir_path)
		return result
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".tres"):
			var resource: Resource = ResourceLoader.load(dir_path + "/" + file, type)
			if resource is ResourceElement:
				result.append(resource)
	return result
