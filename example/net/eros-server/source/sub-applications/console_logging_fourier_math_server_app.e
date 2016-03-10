note
	description: "Summary description for {CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:06 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP

inherit
	FOURIER_MATH_SERVER_APP
		redefine
			Option_name, Description, Installer,  Log_filter
		end

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "console_logging_fourier_math"
		end

	Description: STRING
		once
			Result := Precursor + " (with console logging)"
		end

	Installer: EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER
			--
		once
			create Result.make (Current, Menu_path, new_launcher ("Fourier math server" , Icon_path_server_menu))
			Result.set_command_line_options ("-logging -console -max_threads 3")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := Precursor
			Result [1] := [{CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP}, "*"]
		end

end
