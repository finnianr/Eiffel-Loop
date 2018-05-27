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
	date: "2018-05-27 18:12:46 GMT (Sunday 27th May 2018)"
	revision: "3"

class
	FOURIER_MATH_TEST_SERVER_APP

inherit
	EL_SERVER_SUB_APPLICATION
		redefine
			option_name, initialize
		end

	EL_INSTALLABLE_SUB_APPLICATION

	APPLICATION_MENUS

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

feature {NONE} -- Constants

	Option_name: STRING = "test_server"

	Description: STRING = "Single connection test server for fourier math (Ctrl-c to shutdown)"

	Installer: EL_APPLICATION_INSTALLER_I
			--
		once
			create {EL_DESKTOP_CONSOLE_APPLICATION_INSTALLER_IMP} Result.make (
				Current, Menu_path, new_launcher ("Fourier math server-lite", Icon_path_server_lite_menu)
			)
			Result.set_command_line_options ("-logging")
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{FOURIER_MATH_TEST_SERVER_APP}, "*"],
				[{EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER}, "*"],
				[{FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}, "-*"],
				[{SIGNAL_MATH}, "-*"]
			>>
		end

end
