note
	description: "Sub-application to aid development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-07 15:39:39 GMT (Tuesday 7th January 2020)"
	revision: "60"

class
	BASE_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{BASE_AUTOTEST_APP}, All_routines]
			>>
		end

feature {NONE} -- Constants

	Evaluator_types: TUPLE [DATE_TEXT_TEST_EVALUATOR]
		once
			create Result
		end

	Evaluator_types_all: TUPLE [
		DATE_TEXT_TEST_EVALUATOR,
		FILE_AND_DIRECTORY_TEST_EVALUATOR,
		REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_EVALUATOR,
		ZSTRING_TEST_EVALUATOR
	]
		once
			create Result
		end

	Option_name: STRING = "base_autotest"

end
