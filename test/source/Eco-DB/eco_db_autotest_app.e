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
	date: "2020-12-21 13:18:38 GMT (Monday 21st December 2020)"
	revision: "16"

class
	ECO_DB_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [ECD_READER_WRITER_TEST_SET]
		redefine
			log_filter_set
		end

create
	make

feature {NONE} -- Implementation

	log_filter_set: EL_LOG_FILTER_SET [like Current, ECD_READER_WRITER_TEST_SET]
		do
			create Result.make
		end

end