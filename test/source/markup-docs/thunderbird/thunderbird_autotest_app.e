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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-30 17:34:36 GMT (Friday 30th December 2022)"
	revision: "70"

class
	THUNDERBIRD_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [THUNDERBIRD_EXPORT_TEST_SET]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	visible_types: TUPLE [THUNDERBIRD_EXPORT_TEST_SET]
		do
			create Result
		end
end