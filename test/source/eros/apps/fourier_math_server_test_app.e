note
	description: "[
		Single threaded test server.
		Notes:
			For finalized exe use Ctrl-c to exit nicely.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "17"

class
	FOURIER_MATH_SERVER_TEST_APP

inherit
	EROS_SERVER_APPLICATION [FOURIER_MATH_SERVER_COMMAND]

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


end