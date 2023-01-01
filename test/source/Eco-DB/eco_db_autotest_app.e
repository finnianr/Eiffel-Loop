note
	description: "Finalized executable tests for library [./library/Eco-DB.html Eco-DB.ecf]"
	notes: "[
		Command option: `-eco_db_autotest'
		
		**Test Sets**
		
			[$source ECD_READER_WRITER_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 17:55:31 GMT (Saturday 31st December 2022)"
	revision: "22"

class
	ECO_DB_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [ECD_READER_WRITER_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		ECD_REFLECTIVE_INDEX_TABLE [EL_REFLECTIVELY_SETTABLE_STORABLE, HASHABLE],
		ECD_INDEX_TABLE_REPRESENTATION [EL_REFLECTIVELY_SETTABLE_STORABLE, HASHABLE]
	]
		do
			create Result
		end

end