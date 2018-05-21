note
	description: "Console logging fourier math server app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP

inherit
	FOURIER_MATH_SERVER_APP
		redefine
			Option_name, Description, Installer,  Log_filter, Is_main
		end

feature {NONE} -- Constants

	Is_main: BOOLEAN = True

	Option_name: STRING
		once
			Result := "console_logging_fourier_math"
		end

	Description: STRING
		once
			Result := Precursor + " (with console logging)"
		end

	Installer: EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_I
			--
		once
			create {EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_IMP} Result.make (Current, Menu_path, new_launcher ("Fourier math server" , Icon_path_server_menu))
			Result.set_command_line_options ("-logging -console -max_threads 3")
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := Precursor
			Result [1] := [{CONSOLE_LOGGING_FOURIER_MATH_SERVER_APP}, "*"]
		end

end
