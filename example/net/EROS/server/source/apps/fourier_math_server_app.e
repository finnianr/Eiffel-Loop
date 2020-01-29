note
	description: "Fourier math server app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-21 11:36:37 GMT (Tuesday 21st January 2020)"
	revision: "10"

class
	FOURIER_MATH_SERVER_APP

inherit
	EROS_REMOTE_ROUTINE_CALL_SERVER_APPLICATION
		redefine
			Option_name
		end

	INSTALLABLE_EROS_SUB_APPLICATION
		redefine
			name
		end

create
	make

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{SIGNAL_MATH}, All_routines],
				[{FFT_COMPLEX_64}, All_routines],
				[{EROS_REMOTE_ROUTINE_CALL_SERVER_MAIN_WINDOW}, All_routines],
				[{EROS_CALL_REQUEST_DELEGATING_CONSUMER_THREAD}, All_routines],
				[{EROS_CALL_REQUEST_CONNECTION_MANAGER_THREAD}, All_routines],
				[{EROS_CALL_REQUEST_HANDLING_THREAD}, All_routines],
				[{EROS_CALL_REQUEST_HANDLER}, All_routines],
				[{EROS_SERVER_ACTIVITY_METERS}, "prompt_refresh, refresh"]
			>>
		end

feature {NONE} -- Remotely callable types

	callable_classes: TUPLE [SIGNAL_MATH, FFT_COMPLEX_DOUBLE]

feature {NONE} -- Installer constants

	Desktop: EL_DESKTOP_ENVIRONMENT_I
			--
		once
			Result := new_menu_desktop_environment
			Result.set_command_line_options (<< Base_option.Opt_silent, "max_threads 3" >>)
		end

	desktop_launcher: EL_DESKTOP_MENU_ITEM
		do
			Result := new_launcher ("fourier-server.png")
		end

	name: ZSTRING
		do
			Result := "Fourier Transform Math"
			Result.append (name_qualifier)
		end

	name_qualifier: ZSTRING
		do
			Result := " (NO CONSOLE)"
		end

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "EROS server to do fourier transformations on signal waveforms"
		end

	Option_name: STRING
		once
			Result := "fourier_math"
		end

end