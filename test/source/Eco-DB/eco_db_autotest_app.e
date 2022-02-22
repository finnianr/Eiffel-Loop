note
	description: "Finalized executable tests for library [./library/Eco-DB.html Eco-DB.ecf]"
	notes: "[
		Command option: `-eco_db_autotest'
		
		**Test Sets**
		
			[$source ECD_READER_WRITER_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-22 15:48:50 GMT (Tuesday 22nd February 2022)"
	revision: "19"

class
	ECO_DB_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [ECD_READER_WRITER_TEST_SET]
		redefine
			log_filter_set
		end

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

	log_filter_set: EL_LOG_FILTER_SET [like Current, ECD_READER_WRITER_TEST_SET]
		do
			create Result.make
		end

end