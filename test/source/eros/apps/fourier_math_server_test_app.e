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
	date: "2022-02-06 16:43:09 GMT (Sunday 6th February 2022)"
	revision: "15"

class
	FOURIER_MATH_SERVER_TEST_APP

inherit
	EROS_SERVER_APPLICATION

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Implementation

	log_filter_set: EL_LOG_FILTER_SET [
		like Current,
		EROS_CALL_REQUEST_HANDLER,
		FFT_COMPLEX_64,
		SIGNAL_MATH
	]
		do
			create Result.make
		end

feature {NONE} -- Internal attributes

	compile: TUPLE [FFT_COMPLEX_64, SIGNAL_MATH]
		do
			create Result
		end

feature {NONE} -- Constants

	Description: STRING = "Single connection test server for fourier math (Ctrl-c to shutdown)"

end