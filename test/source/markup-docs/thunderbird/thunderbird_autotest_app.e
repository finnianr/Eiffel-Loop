note
	description: "Developer tests for Thunderbird email export classes"
	notes: "Option: `-thunderbird_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 9:53:33 GMT (Friday 31st January 2020)"
	revision: "61"

class
	THUNDERBIRD_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	evaluator_type, evaluator_types_all: TUPLE [EL_SUBJECT_LINE_DECODER_TEST_EVALUATOR]
		do
			create Result
		end

end
