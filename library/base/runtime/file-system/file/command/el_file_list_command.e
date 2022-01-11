note
	description: "Command to process a list of files on execution"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-11 17:56:26 GMT (Tuesday 11th January 2022)"
	revision: "1"

deferred class
	EL_FILE_LIST_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_MODULE_TRACK

feature {NONE} -- Initialization

	make_default
		do
			sorted := False
		end

feature -- Basic operations

	execute
		local
			file_list: like new_file_list
		do
			file_list := new_file_list
			if sorted.is_enabled then
				file_list.sort
			end

			lio.put_labeled_substitution ("Processsing", "%S files", [file_list.count])
			lio.put_new_line
			Track.progress (Console_display, file_list.count, agent iterate_files (file_list))
			lio.put_new_line
		end

feature -- Status query

	sorted: EL_BOOLEAN_OPTION
		-- enable to sort files before processing

feature {NONE} -- Implementation

	do_with_file (file_path: FILE_PATH)
		deferred
		end

	iterate_files (file_list: ITERABLE [FILE_PATH])
		do
			across file_list as file_path loop
				do_with_file (file_path.item)
				Track.progress_listener.notify_tick
			end
		end

	new_file_list: EL_FILE_PATH_LIST
		deferred
		end

end