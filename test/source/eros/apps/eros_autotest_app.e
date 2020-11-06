note
	description: "Finalized executable tests for library [./library/eros.html eros.ecf]"
	notes: "[
		Command option: `-amazon_instant_access_autotest'

		**Test Sets**

			[$source EROS_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-06 16:42:46 GMT (Friday 6th November 2020)"
	revision: "10"

class
	EROS_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [EROS_TEST_SET]
		redefine
			log_filter_list
		end

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [ROW_VECTOR_COMPLEX_64]
		do
			create Result
		end

	log_filter_list: EL_LOG_FILTER_LIST [
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