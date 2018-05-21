note
	description: "Fourier math server app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	FOURIER_MATH_SERVER_APP

inherit
	EL_REMOTE_ROUTINE_CALL_SERVER_APPLICATION
		redefine
			Option_name, Installer
		end

	APPLICATION_MENUS
		undefine
			default_create, copy
		end

create
	make

feature {NONE} -- Remotely callable types

	callable_classes: TUPLE [SIGNAL_MATH, FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE]

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "fourier_math"
		end

	Description: STRING
		once
			Result := "EROS server to do fourier transformations on signal waveforms"
		end

	Installer: EL_DESKTOP_APPLICATION_INSTALLER_I
			--
		once
			create {EL_DESKTOP_APPLICATION_INSTALLER_IMP} Result.make (
				Current, Menu_path, new_launcher ("Fourier math server (NO CONSOLE)", Icon_path_server_menu)
			)
			Result.set_command_line_options ("-max_threads 3")
		end

	name: STRING = "Fourier Transform Math"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{FOURIER_MATH_SERVER_APP}, All_routines],
				[{SIGNAL_MATH}, All_routines],
				[{FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}, All_routines],
				[{EL_REMOTE_ROUTINE_CALL_SERVER_MAIN_WINDOW}, All_routines],
				[{EL_REMOTE_CALL_REQUEST_DELEGATING_CONSUMER_THREAD}, All_routines],
				[{EL_REMOTE_CALL_CONNECTION_MANAGER_THREAD}, All_routines],
				[{EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLING_THREAD}, All_routines],
				[{EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER}, All_routines],
				[{EL_SERVER_ACTIVITY_METERS}, "prompt_refresh, refresh"]
			>>
		end

end
