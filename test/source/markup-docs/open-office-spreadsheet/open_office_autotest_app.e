note
	description: "Test Open Office classes"
	notes: "Option: `-open_office_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-02 9:28:11 GMT (Sunday 2nd February 2020)"
	revision: "11"

class
	OPEN_OFFICE_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION
		redefine
			log_filter
		end

create
	make

feature {NONE} -- Implementation

	evaluator_type, evaluator_types_all: TUPLE [OPEN_OFFICE_TEST_EVALUATOR]
		do
			create Result
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{OPEN_OFFICE_TEST_SET}, All_routines]
			>>
		end

end
