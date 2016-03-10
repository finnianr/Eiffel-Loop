note
	description: "Summary description for {EL_LOG_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_LOG_CONSTANTS

inherit
	EL_CROSS_PLATFORM_ABS

feature -- Constants

	Clear_screen_command: STRING
			--
		once
			Result := implementation.Clear_screen_command
		end

	Command_arg_activate_console_manager: STRING
			--
		once
			Result := implementation.Command_arg_activate_console_manager
		end

	Command_arg_activate_logging: STRING
			--
		once
			Result := implementation.Command_arg_activate_logging
		end

feature {NONE} -- Implementation

	Implementation: EL_LOG_CONSTANTS_IMPL
			--
		once
			create Result
		end

end
