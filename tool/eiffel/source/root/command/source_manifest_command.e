note
	description: "[
		Process files specified in a Pyxis format source manifest as for example:
		[https://github.com/finnianr/Eiffel-Loop/blob/master/sources.pyx sources.pyx]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-03 12:33:12 GMT (Thursday 3rd February 2022)"
	revision: "13"

deferred class
	SOURCE_MANIFEST_COMMAND

inherit
	EL_FILE_LIST_COMMAND
		redefine
			execute, make_default
		end

feature {EL_COMMAND_CLIENT} -- Initialization

	make (source_manifest_path: FILE_PATH)
		do
			make_default
			create manifest.make_from_file (source_manifest_path)
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