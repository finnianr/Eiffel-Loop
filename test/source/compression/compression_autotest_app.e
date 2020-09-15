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
	date: "2020-09-15 10:19:56 GMT (Tuesday 15th September 2020)"
	revision: "2"

class
	COMPRESSION_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [TUPLE [COMPRESSION_TEST_SET]]

create
	make

end