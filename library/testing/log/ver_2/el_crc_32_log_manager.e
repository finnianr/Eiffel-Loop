note
	description: "[$source EL_LOG_MANAGER] with CRC-32 checksum attached to log outputs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-18 11:44:10 GMT (Tuesday 18th January 2022)"
	revision: "8"

class
	EL_CRC_32_LOG_MANAGER

inherit
	EL_LOG_MANAGER
		redefine
			new_output, new_highlighted_output
		end

create
	make

feature {NONE} -- Factory

	new_highlighted_output (log_path: FILE_PATH; a_thread_name: STRING; a_index: INTEGER): like new_log_file
		do
			create {EL_CRC_32_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make (log_path, a_thread_name, a_index)
		end

	new_output (log_path: FILE_PATH; a_thread_name: STRING; a_index: INTEGER): like new_log_file
		do
			create {EL_CRC_32_FILE_AND_CONSOLE_LOG_OUTPUT} Result.make (log_path, a_thread_name, a_index)
		end

end