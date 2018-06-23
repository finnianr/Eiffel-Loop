note
	description: "Logged command line sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-19 10:41:32 GMT (Tuesday 19th June 2018)"
	revision: "1"

deferred class
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]
		undefine
			new_lio, do_application, init_logging, io_put_header, standard_options
		end

	EL_LOGGED_SUB_APPLICATION
end
