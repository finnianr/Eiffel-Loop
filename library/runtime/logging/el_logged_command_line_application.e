note
	description: "Logged version of [$source EL_COMMAND_LINE_APPLICATION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

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