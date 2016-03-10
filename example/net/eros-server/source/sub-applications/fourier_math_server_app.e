note
	description: "Summary description for {FOURIER_MATH_SERVER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-04 10:04:18 GMT (Saturday 4th January 2014)"
	revision: "2"

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

	Installer: EL_DESKTOP_APPLICATION_INSTALLER
			--
		once
			create Result.make (
				Current, Menu_path, new_launcher ("Fourier math server (NO CONSOLE)", Icon_path_server_menu)
			)
			Result.set_command_line_options ("-max_threads 3")
		end

	name: STRING = "Fourier Transform Math"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{FOURIER_MATH_SERVER_APP}, "*"],
				[{SIGNAL_MATH}, "*"],
				[{FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}, "*"],
				[{EL_REMOTE_ROUTINE_CALL_SERVER_MAIN_WINDOW}, "*"],
				[{EL_REMOTE_CALL_REQUEST_DELEGATING_CONSUMER_THREAD}, "*"],
				[{EL_REMOTE_CALL_CONNECTION_MANAGER_THREAD}, "*"],
				[{EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLING_THREAD}, "*"],
				[{EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER}, "*"],
				[{EL_REMOTE_CALL_CLIENT_CONNECTION_QUEUE}, "*"],
				[{EL_SERVER_ACTIVITY_METERS}, "prompt_refresh, refresh"]
			>>
		end

end
