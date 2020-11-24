note
	description: "Finalized executable tests for library [./library/compression.html compression.ecf]"
	notes: "[
		Command option: `-compression_autotest'
		
		Test set: [$source COMPRESSION_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-24 10:39:53 GMT (Tuesday 24th November 2020)"
	revision: "3"

class
	COMPRESSION_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [COMPRESSION_TEST_SET]

create
	make

end