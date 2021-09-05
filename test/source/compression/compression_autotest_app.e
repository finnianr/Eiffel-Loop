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
	date: "2021-09-01 10:50:47 GMT (Wednesday 1st September 2021)"
	revision: "4"

class
	COMPRESSION_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [COMPRESSION_TEST_SET]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	visible_types: TUPLE [EL_COPY_TREE_COMMAND_IMP]
		do
			create Result
		end

end