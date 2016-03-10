note
	description: "Summary description for {CONSOLE_LOGGING_QUANTUM_BALL_ANIMATION_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	CONSOLE_LOGGING_QUANTUM_BALL_ANIMATION_APP

inherit
	QUANTUM_BALL_ANIMATION_APP
		redefine
			Option_name, Description, Installer,  Log_filter
		end

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "console_logging_animation"
		end

	Description: STRING
		once
			Result := Precursor + " with console logging"
		end

	Installer: EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER
			--
		once
			create Result.make (
				Current, << Development_menu, Eiffel_loop_menu >>, new_launcher ("Physics lesson", Icon_path_animation)
			)
			Result.set_command_line_options ("-logging -console")
		end


	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := Precursor
			Result [1] := [{CONSOLE_LOGGING_QUANTUM_BALL_ANIMATION_APP}, "*"]
		end
end
