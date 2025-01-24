note
	description: "[
		Arrayed list of ${EL_WEB_SERVER_LOG} with entries list in reverse chronological order
		of modification time.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-23 17:52:20 GMT (Thursday 23rd January 2025)"
	revision: "1"

class
	EL_WEB_SERVER_LOG_LIST

inherit
	EL_ARRAYED_LIST [EL_WEB_SERVER_LOG]
		rename
			make as make_list
		end

	EL_MODULE_OS

create
	make

feature {NONE} -- Initialization

	make (log_path: FILE_PATH)
		require
			log_path_exists: log_path.exists
		local
			log_path_wildcard: FILE_PATH
		do
			log_path_wildcard := log_path.twin
			log_path_wildcard.add_extension ("*")
			if attached OS.file_pattern_list (log_path_wildcard) as file_list then
				make_list (file_list.count)
				across file_list as list loop
					extend (create {EL_WEB_SERVER_LOG}.make (list.item))
				end
				order_by (agent {EL_WEB_SERVER_LOG}.modification_time, False)
			else
				make_empty
			end
		end

end