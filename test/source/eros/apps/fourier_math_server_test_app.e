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
	date: "2020-11-06 16:35:34 GMT (Friday 6th November 2020)"
	revision: "12"

class
	FOURIER_MATH_SERVER_TEST_APP

inherit
	EROS_SERVER_SUB_APPLICATION

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Implementation

	log_filter_list: EL_LOG_FILTER_LIST [
		like Current,
		EROS_CALL_REQUEST_HANDLER,
		FFT_COMPLEX_64,
		SIGNAL_MATH
	]
		do
			create Result.make
		end

feature {NONE} -- Internal attributes

	tuple: TUPLE [FFT_COMPLEX_64, SIGNAL_MATH]

feature {NONE} -- Constants

	Description: STRING = "Single connection test server for fourier math (Ctrl-c to shutdown)"

end