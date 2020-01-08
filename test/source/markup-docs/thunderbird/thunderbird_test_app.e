note
	description: "Developer tests for Thunderbird email export classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 12:31:54 GMT (Wednesday 8th January 2020)"
	revision: "60"

class
	THUNDERBIRD_TEST_APP

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
