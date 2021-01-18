note
	description: "[
		Process files specified in a Pyxis format source manifest as for example:
		[https://github.com/finnianr/Eiffel-Loop/blob/master/sources.pyx sources.pyx]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-18 13:32:36 GMT (Monday 18th January 2021)"
	revision: "6"

deferred class
	SOURCE_MANIFEST_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_ITERATION_OUTPUT

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			create manifest.make_default
		end

	make (source_manifest_path: EL_FILE_PATH)
		do
			create manifest.make_from_file (source_manifest_path)
		end

feature -- Basic operations

	execute
		local
			file_list: like manifest.file_list
			count_x_50: INTEGER
		do
			across manifest.locations as location loop
				lio.put_line (location.item.dir_path)
			end
			lio.put_new_line
			if is_ordered then
				file_list := manifest.sorted_file_list
			else
				file_list := manifest.file_list
			end
			across file_list as file_path loop
				print_progress ((file_path.cursor_index - 1).to_natural_32)
				process_file (file_path.item)
			end
		end

	process_file (source_path: EL_FILE_PATH)
		deferred
		end

feature -- Access

	manifest: SOURCE_MANIFEST

feature -- Status query

	is_ordered: BOOLEAN
		do
		end

	Iterations_per_dot: NATURAL_32 = 50

end