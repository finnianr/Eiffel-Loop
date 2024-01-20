note
	description: "${EL_LOG_MANAGER} with CRC-32 checksum attached to log outputs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "12"

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

	new_highlighted_output (log_path: FILE_PATH; a_thread_name: READABLE_STRING_GENERAL; a_index: INTEGER): like new_log_file
		do
			create {EL_CRC_32_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make (log_path, a_thread_name, a_index)
		end

	new_output (log_path: FILE_PATH; a_thread_name: READABLE_STRING_GENERAL; a_index: INTEGER): like new_log_file
		do
			create {EL_CRC_32_FILE_AND_CONSOLE_LOG_OUTPUT} Result.make (log_path, a_thread_name, a_index)
		end

end