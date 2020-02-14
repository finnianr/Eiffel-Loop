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
	date: "2020-02-14 13:53:52 GMT (Friday 14th February 2020)"
	revision: "7"

class
	EROS_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION
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

	test_type, test_types_all: TUPLE [EROS_TEST_SET]
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
