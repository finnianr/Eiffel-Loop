note
	description: "Finalized executable tests for library [./library/Eco-DB.html Eco-DB.ecf]"
	notes: "[
		Command option: `-eco_db_autotest'
		
		**Test Sets**
		
			${ECD_READER_WRITER_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 7:29:43 GMT (Saturday 22nd March 2025)"
	revision: "25"

class
	ECO_DB_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [ECD_READER_WRITER_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		ECD_AGENT_INDEX_TABLE [EL_STORABLE, HASHABLE],
		ECD_INDEX_TABLE_REPRESENTATION [EL_REFLECTIVELY_SETTABLE_STORABLE, HASHABLE],
		ECD_KEY_INDEX [EL_KEY_IDENTIFIABLE_STORABLE],
		ECD_GROUP_TABLE [EL_STORABLE, HASHABLE],
		ECD_PRIMARY_KEY_INDEXABLE [EL_KEY_IDENTIFIABLE_STORABLE],
		ECD_REFLECTIVE_INDEX_TABLE [EL_REFLECTIVELY_SETTABLE_STORABLE, HASHABLE]
	]
		do
			create Result
		end

end