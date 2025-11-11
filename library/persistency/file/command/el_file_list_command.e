note
	description: "Command to process a list of files on execution"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-10 7:20:03 GMT (Monday 10th November 2025)"
	revision: "7"

deferred class
	EL_FILE_LIST_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LIO; EL_MODULE_TRACK

feature {NONE} -- Initialization

	make_default
		do
			sorted := False
			progress_tracking := True
		end

feature -- Basic operations

	execute
		local
			file_list: like new_file_list
		do
			file_list := new_file_list
			if sorted.is_enabled then
				file_list.ascending_sort
			end

			lio.put_labeled_substitution ("Processsing", "%S files", [file_list.count])
			lio.put_new_line
			if progress_tracking.is_enabled then
				Track.progress (Console_display, file_list.count, agent iterate_files (file_list))
			else
				iterate_files (file_list)
			end
			lio.put_new_line
		end

feature -- Status query

	sorted: EL_BOOLEAN_OPTION
		-- enable to sort files before processing

	progress_tracking: EL_BOOLEAN_OPTION
		-- disable to turn off console progress tracking bar

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