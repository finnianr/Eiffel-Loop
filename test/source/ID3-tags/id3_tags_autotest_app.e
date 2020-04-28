note
	description: "Finalized executable tests for library [./library/ID3-tags.html ID3-tags.ecf]"
	notes: "[
		Command option: `-id3_tags_autotest'
		
		**Test Sets**
		
			[$source ID3_TAG_INFO_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 13:57:19 GMT (Friday 14th February 2020)"
	revision: "62"

class
	ID3_TAGS_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type, test_types_all: TUPLE [ID3_TAG_INFO_TEST_SET]
		do
			create Result
		end

end
