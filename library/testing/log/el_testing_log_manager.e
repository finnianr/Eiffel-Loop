note
	description: "Extends `EL_LOG_MANAGER' for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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

	make (a_crc_32: like crc_32)
		do
			crc_32 := a_crc_32
			make_manager
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