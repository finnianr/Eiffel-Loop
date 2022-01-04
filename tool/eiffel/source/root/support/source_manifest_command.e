note
	description: "[
		Process files specified in a Pyxis format source manifest as for example:
		[https://github.com/finnianr/Eiffel-Loop/blob/master/sources.pyx sources.pyx]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-04 15:39:28 GMT (Tuesday 4th January 2022)"
	revision: "10"

deferred class
	SOURCE_MANIFEST_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_MODULE_TRACK

feature {EL_COMMAND_CLIENT} -- Initialization

	make (source_manifest_path: FILE_PATH)
		do
			create manifest.make_from_file (source_manifest_path)
		end

	make_default
		do
			create manifest.make_default
		end

feature -- Basic operations

	execute
		local
			file_list: like manifest.file_list
		do
			across manifest.source_tree_list as location loop
				lio.put_line (location.item.dir_path)
			end
			lio.put_new_line
			if is_ordered then
				file_list := manifest.sorted_file_list
			else
				file_list := manifest.file_list
			end
			lio.put_labeled_substitution ("Processsing", "%S files", [file_list.count])
			lio.put_new_line
			Track.progress (Console_display, file_list.count, agent iterate_files (file_list))
			lio.put_new_line
		end

feature {NONE} -- Implementation

	iterate_files (file_list: ITERABLE [FILE_PATH])
		do
			across file_list as file_path loop
				process_file (file_path.item)
				Track.progress_listener.notify_tick
			end
		end

	process_file (source_path: FILE_PATH)
		deferred
		end

feature -- Access

	manifest: SOURCE_MANIFEST

feature -- Status query

	is_ordered: BOOLEAN
		do
		end

end