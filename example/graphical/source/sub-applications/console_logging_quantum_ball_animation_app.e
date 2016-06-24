note
	description: "Summary description for {CONSOLE_LOGGING_QUANTUM_BALL_ANIMATION_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 9:27:10 GMT (Friday 24th June 2016)"
	revision: "4"

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

	Installer: EL_APPLICATION_INSTALLER_I
			--
		once
			create {EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_IMP} Result.make (
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
