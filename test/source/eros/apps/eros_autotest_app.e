note
	description: "Eros autotest app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 9:51:52 GMT (Monday 20th January 2020)"
	revision: "2"

class
	EROS_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			log_filter
		end

create
	make

feature {NONE} -- Implementation

	evaluator_type, evaluator_types_all: TUPLE [EROS_TEST_EVALUATOR]
		do
			create Result
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{FFT_COMPLEX_DOUBLE_PROXY}, All_routines],
				[{SIGNAL_MATH_PROXY}, All_routines],
				[{EROS_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_PROXY}, All_routines]
			>>
		end

end
