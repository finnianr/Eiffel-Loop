note
	description: "[
		Finalized executable tests for library cluster [./library/markup-docs.thunderbird.html markup-docs.ecf#thunderbird]
	]"
	notes: "[
		Command option: `-thunderbird_autotest'
		
		**Test Sets**
		
			[$source EL_SUBJECT_LINE_DECODER_TEST_SET]
	]"
	description: "[
		Finalized executable tests for library cluster [./library/markup-docs.thunderbird.html markup-docs.ecf#thunderbird]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 13:59:57 GMT (Friday 14th February 2020)"
	revision: "63"

class
	THUNDERBIRD_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type, test_types_all: TUPLE [EL_SUBJECT_LINE_DECODER_TEST_SET]
		do
			create Result
		end

end
