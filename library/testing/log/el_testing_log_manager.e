note
	description: "Extends [$source EL_LOG_MANAGER] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 8:36:30 GMT (Monday 6th January 2020)"
	revision: "5"

class
	EL_TESTING_LOG_MANAGER

inherit
	EL_LOG_MANAGER
		rename
			make as make_manager
		redefine
			new_output, new_highlighted_output
		end

create
	make

feature -- Initialization

	make (logging_active: BOOLEAN; a_output_directory: EL_DIR_PATH; a_crc_32: like crc_32)
		do
			crc_32 := a_crc_32
			make_manager (logging_active, a_output_directory)
		end

feature {NONE} -- Factory

	new_highlighted_output (log_path: EL_FILE_PATH; a_thread_name: STRING; a_index: INTEGER): like new_log_file
		do
			create {EL_TESTING_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make (log_path, a_thread_name, a_index, crc_32)
		end

	new_output (log_path: EL_FILE_PATH; a_thread_name: STRING; a_index: INTEGER): like new_log_file
		do
			create {EL_TESTING_FILE_AND_CONSOLE_LOG_OUTPUT} Result.make (log_path, a_thread_name, a_index, crc_32)
		end

feature {NONE} -- Internal attributes

	crc_32: EL_CYCLIC_REDUNDANCY_CHECK_32

end
