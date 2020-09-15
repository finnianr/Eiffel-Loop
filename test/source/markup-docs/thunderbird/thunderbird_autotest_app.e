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
	date: "2020-09-15 10:21:59 GMT (Tuesday 15th September 2020)"
	revision: "64"

class
	THUNDERBIRD_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [TUPLE [EL_SUBJECT_LINE_DECODER_TEST_SET]]

create
	make

end