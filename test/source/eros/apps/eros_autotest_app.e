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
	date: "2020-10-18 12:59:09 GMT (Sunday 18th October 2020)"
	revision: "9"

class
	EROS_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [EROS_TEST_SET]
		redefine
			log_filter
		end

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [ROW_VECTOR_COMPLEX_64]
		do
			create Result
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{FFT_COMPLEX_64_PROXY}, All_routines],
				[{SIGNAL_MATH_PROXY}, All_routines],
				[{EROS_CALL_REQUEST_HANDLER_PROXY}, All_routines],
				[{EROS_TEST_SET}, All_routines]
			>>
		end

end