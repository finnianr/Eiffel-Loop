note
	description: "GVFS command to move/copy a file"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 8:52:44 GMT (Tuesday 9th July 2024)"
	revision: "4"

deferred class
	EL_GVFS_URI_TRANSFER_COMMAND

inherit
	EL_GVFS_OS_COMMAND [TUPLE [source_path, destination_path: STRING]]

feature -- Element change

	set_destination_path (path: EL_PATH)
		do
			put_path (Var.destination_path, path)
		end

	set_destination_uri (uri: EL_URI)
		do
			put_uri (Var.destination_path, uri)
		end

	set_source_path (path: EL_PATH)
		do
			put_path (Var.source_path, path)
		end

	set_source_uri (uri: EL_URI)
		do
			put_uri (Var.source_path, uri)
		end

feature {NONE} -- Implementation

	default_template: STRING
		do
			Result := "gvfs-" + operation_name + " $source_path $destination_path"
		end

	operation_name: STRING
--			Eg. EL_GVFS_MOVE_COMMAND -> move
		do
			Result := Naming.class_as_snake_lower (Current, 2, 1)
		end

end