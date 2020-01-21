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
	date: "2020-01-21 13:10:42 GMT (Tuesday 21st January 2020)"
	revision: "11"

class
	FOURIER_MATH_SERVER_TEST_APP

inherit
	EROS_SERVER_SUB_APPLICATION

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{EROS_CALL_REQUEST_HANDLER}, All_routines],
				[{FFT_COMPLEX_64}, No_routines],
				[{SIGNAL_MATH}, No_routines]
			>>
		end

feature {NONE} -- Internal attributes

	tuple: TUPLE [FFT_COMPLEX_64, SIGNAL_MATH]

feature {NONE} -- Constants

	Description: STRING = "Single connection test server for fourier math (Ctrl-c to shutdown)"

end
