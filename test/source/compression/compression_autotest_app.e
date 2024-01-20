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
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "7"

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