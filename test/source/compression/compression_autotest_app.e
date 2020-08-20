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
	date: "2020-08-20 11:32:55 GMT (Thursday 20th August 2020)"
	revision: "1"

class
	COMPRESSION_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type: TUPLE [COMPRESSION_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [COMPRESSION_TEST_SET]
		do
			create Result
		end
end
