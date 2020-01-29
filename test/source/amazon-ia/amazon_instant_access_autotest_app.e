note
	description: "Sub-application to call tests in [$source AMAZON_INSTANT_ACCESS_TEST_SET]"
	instructions: "Command option: `-amazon_instant_access_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-24 17:16:15 GMT (Friday 24th January 2020)"
	revision: "63"

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