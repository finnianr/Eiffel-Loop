note
	description: "Summary description for {EL_LOG_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_LOG_CONSTANTS_IMPL

inherit
	EL_PLATFORM_IMPL

feature {EL_LOG_CONSTANTS} -- Constants

	Clear_screen_command: STRING = "clear"

	Command_arg_activate_console_manager: STRING = "console"

	Command_arg_activate_logging: STRING = "logging"

end
