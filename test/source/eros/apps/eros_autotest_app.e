note
	description: "Finalized executable tests for library [./library/eros.html eros.ecf]"
	notes: "[
		Command option: `-amazon_instant_access_autotest'

		**Test Sets**

			${EROS_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "14"

class
	EROS_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [EROS_TEST_SET]
		redefine
			log_filter_set
		end

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [ROW_VECTOR_COMPLEX_64]
		do
			create Result
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current,
		EROS_CALL_REQUEST_HANDLER_PROXY,
		EROS_TEST_SET,
		FFT_COMPLEX_64_PROXY,
		SIGNAL_MATH_PROXY
	]
		do
			create Result.make
		end

end