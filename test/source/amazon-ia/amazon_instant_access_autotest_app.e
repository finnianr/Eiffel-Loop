note
	description: "Sub-application to call tests in [$source AMAZON_INSTANT_ACCESS_TEST_SET]"
	notes: "[
		Command option: `-amazon_instant_access_autotest'
		
		**Tests**
		
		[$source AMAZON_INSTANT_ACCESS_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-03 11:04:14 GMT (Monday 3rd February 2020)"
	revision: "64"

class
	AMAZON_INSTANT_ACCESS_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			log_filter
		end

create
	make

feature {NONE} -- Implementation

	evaluator_type, evaluator_types_all: TUPLE [AMAZON_INSTANT_ACCESS_TEST_EVALUATOR]
		do
			create Result
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{AMAZON_INSTANT_ACCESS_TEST_SET}, All_routines]
			>>
		end

end
