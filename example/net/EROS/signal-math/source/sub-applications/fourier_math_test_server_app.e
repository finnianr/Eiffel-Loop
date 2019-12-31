note
	description: "[
		Single threaded test server.
		Notes:
			For finalized exe use Ctrl-c to exit nicely.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-14 9:56:43 GMT (Thursday 14th June 2018)"
	revision: "5"

class
	FOURIER_MATH_TEST_SERVER_APP

inherit
	EL_SERVER_SUB_APPLICATION
		redefine
			option_name, initialize
		end

	INSTALLABLE_SUB_APPLICATION
		redefine
			name
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			Precursor
			create request_handler.make
		end

feature -- Basic operations

	serve (client_socket: like connecting_socket)
			--
		do
			request_handler.serve (connecting_socket.accepted)
		end

feature {NONE} -- Implementation

	request_handler: EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER

	tuple: TUPLE [FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE, SIGNAL_MATH]

feature {NONE} -- Installer constants

	Desktop_launcher: EL_DESKTOP_MENU_ITEM
		once
			Result := new_launcher ("fourier-server-lite.png")
		end

	Desktop: EL_DESKTOP_ENVIRONMENT_I
			--
		once
			Result := new_console_app_menu_desktop_environment
			Result.set_command_line_options (<< Log_option.Name.Logging >>)
		end

	Name: ZSTRING
		once
			Result := "Fourier math server-lite"
		end

feature {NONE} -- Constants

	Description: STRING = "Single connection test server for fourier math (Ctrl-c to shutdown)"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{FOURIER_MATH_TEST_SERVER_APP}, All_routines],
				[{EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER}, All_routines],
				[{FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}, No_routines],
				[{SIGNAL_MATH}, No_routines]
			>>
		end

	Option_name: STRING = "test_server"

end
