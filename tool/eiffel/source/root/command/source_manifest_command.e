note
	description: "[
		Process files specified in a Pyxis format source manifest as for example:
		[https://github.com/finnianr/Eiffel-Loop/blob/master/sources.pyx sources.pyx]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 11:51:12 GMT (Saturday 5th February 2022)"
	revision: "14"

deferred class
	SOURCE_MANIFEST_COMMAND

inherit
	EL_FILE_LIST_COMMAND
		redefine
			execute, make_default
		end

	EL_MODULE_FILE_SYSTEM

feature {EL_COMMAND_CLIENT} -- Initialization

	make (manifest_path_or_directory: FILE_PATH)
		do
			make_default
			if File_system.is_directory (manifest_path_or_directory) then
				create manifest.make_from_directory (manifest_path_or_directory.to_string)
			else
				create manifest.make_from_file (manifest_path_or_directory)
			end
		end

	make_default
		do
			Precursor
			create manifest.make_default
		end

feature -- Basic operations

	execute
		do
			across manifest.source_tree_list as location loop
				lio.put_line (location.item.dir_path)
			end
			lio.put_new_line
			Precursor
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		deferred
		end

	new_file_list: EL_FILE_PATH_LIST
		do
			Result := manifest.file_list
		end

feature -- Access

	manifest: SOURCE_MANIFEST

end