note
	description: "Finalized executable tests for library [./library/compression.html compression.ecf]"
	notes: "[
		Command option: `-compression_autotest'
		
		Test set: ${COMPRESSION_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	COMPRESSION_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [COMPRESSION_TEST_SET]
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