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
	date: "2020-09-15 10:18:27 GMT (Tuesday 15th September 2020)"
	revision: "64"

class
	ID3_TAGS_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [TUPLE [ID3_TAG_INFO_TEST_SET]]

create
	make

end