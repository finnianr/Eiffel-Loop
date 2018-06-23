note
	description: "Console logging fourier math server app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-14 9:51:14 GMT (Thursday 14th June 2018)"
	revision: "6"

class
	CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP

inherit
	FOURIER_MATH_SERVER_APP
		redefine
			Option_name, Description, name_qualifier, Desktop, is_main
		end

feature {NONE} -- Installer constants

	name_qualifier: ZSTRING
		do
			create Result.make_empty
		end

	Desktop: EL_DESKTOP_ENVIRONMENT_I
			--
		once
			Result := new_console_app_menu_desktop_environment
			Result.set_command_line_options (<<
				{EL_LOG_COMMAND_OPTIONS}.Logging,
				{EL_LOG_COMMAND_OPTIONS}.Thread_toolbar, "max_threads 3"
			>>)
		end

	Is_main: BOOLEAN = True

feature {NONE} -- Constants

	Description: STRING
		once
			Result := Precursor + " (with console logging)"
		end

	Option_name: STRING
		once
			Result := "console_logging_fourier_math"
		end

end
