note
	description: "[
		Process files specified in a Pyxis format source manifest as for example:
		[https://github.com/finnianr/Eiffel-Loop/blob/master/sources.pyx sources.pyx]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-19 7:29:10 GMT (Tuesday 19th July 2016)"
	revision: "1"

deferred class
	EIFFEL_SOURCE_MANIFEST_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LOG

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

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
				if (file_path.cursor_index - 1) \\ 50 = 0 then
					lio.put_character ('.')
					count_x_50 := count_x_50 + 1
					if count_x_50 \\ 100 = 0 then
						lio.put_new_line
					end
				end
				process_file (file_path.item)
			end
		end

	process_file (source_path: EL_FILE_PATH)
		deferred
		end

feature -- Access

	manifest: EIFFEL_SOURCE_MANIFEST

feature -- Status query

	is_ordered: BOOLEAN
		do
		end

end