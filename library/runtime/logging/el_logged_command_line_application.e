note
	description: "Logged version of [$source EL_COMMAND_LINE_APPLICATION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-06 10:46:09 GMT (Thursday 6th October 2022)"
	revision: "7"

deferred class
	EL_LOGGED_COMMAND_LINE_APPLICATION [C -> EL_APPLICATION_COMMAND]

inherit
	EL_COMMAND_LINE_APPLICATION [C]
		rename
			init_console as init_console_and_logging
		undefine
			new_lio, do_application, init_console_and_logging, io_put_header, standard_options
		end

	EL_LOGGED_APPLICATION
		undefine
			read_command_options, options_help
		end
end