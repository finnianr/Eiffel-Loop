note
	description: "Console logging fourier math server app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-09 16:27:44 GMT (Monday 9th September 2024)"
	revision: "12"

class
	CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP

inherit
	FOURIER_MATH_SERVER_APP
		redefine
			Option_name, Description, name_qualifier, Desktop
		end

	EL_MAIN_INSTALLABLE_APPLICATION
		undefine
			name
		redefine
			Option_name
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
				Log_option.Name_logging, Log_option.Name_thread_toolbar, "max_threads 3"
			>>)
		end

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