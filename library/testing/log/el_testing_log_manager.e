note
	description: "Extends [$source EL_LOG_MANAGER] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 11:04:56 GMT (Friday 31st January 2020)"
	revision: "6"

class
	EL_TESTING_LOG_MANAGER

inherit
	EL_LOG_MANAGER
		redefine
			new_output, new_highlighted_output
		end

create
	make

feature {NONE} -- Factory

	new_highlighted_output (log_path: EL_FILE_PATH; a_thread_name: STRING; a_index: INTEGER): like new_log_file
		do
			create {EL_TESTING_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make (log_path, a_thread_name, a_index)
		end

	new_output (log_path: EL_FILE_PATH; a_thread_name: STRING; a_index: INTEGER): like new_log_file
		do
			create {EL_TESTING_FILE_AND_CONSOLE_LOG_OUTPUT} Result.make (log_path, a_thread_name, a_index)
		end

end
