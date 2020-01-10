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
	date: "2020-01-10 9:11:08 GMT (Friday 10th January 2020)"
	revision: "6"

class
	FOURIER_MATH_SERVER_TEST_APP

inherit
	EL_SERVER_SUB_APPLICATION
		redefine
			option_name, initialize
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

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER}, All_routines],
				[{FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE}, No_routines],
				[{SIGNAL_MATH}, No_routines]
			>>
		end

feature {NONE} -- Internal attributes

	request_handler: EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER

	tuple: TUPLE [FAST_FOURIER_TRANSFORM_COMPLEX_DOUBLE, SIGNAL_MATH]

feature {NONE} -- Constants

	Description: STRING = "Single connection test server for fourier math (Ctrl-c to shutdown)"

	Option_name: STRING = "test_server"

end
