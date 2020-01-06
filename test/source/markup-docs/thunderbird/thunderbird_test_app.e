note
	description: "Developer tests for Thunderbird email export classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 20:08:27 GMT (Monday 6th January 2020)"
	revision: "59"

class
	THUNDERBIRD_TEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{THUNDERBIRD_TEST_APP}, All_routines]
			>>
		end

feature {NONE} -- Constants

	Evaluator_types: TUPLE [EL_SUBJECT_LINE_DECODER_TEST_EVALUATOR]
		once
			create Result
		end

end
