note
	description: "Finalized executable tests for library [./library/ID3-tags.html ID3-tags.ecf]"
	notes: "[
		Command option: `-id3_tags_autotest'
		
		**Test Sets**
		
			${ID3_TAG_INFO_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "68"

class
	ID3_TAGS_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [ID3_TAG_INFO_TEST_SET]

create
	make

end