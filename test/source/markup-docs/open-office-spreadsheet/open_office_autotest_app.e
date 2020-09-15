note
	description: "[
		Finalized executable tests for library cluster [./library/markup-docs.open_office.html markup-docs.ecf#open_office]
	]"
	notes: "[
		Command option: `-open_office_autotest'
		
		**Test Sets**
		
			[$source OPEN_OFFICE_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-15 10:21:45 GMT (Tuesday 15th September 2020)"
	revision: "14"

class
	OPEN_OFFICE_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [TUPLE [OPEN_OFFICE_TEST_SET]]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	visible_types: TUPLE [EL_SPREAD_SHEET, EL_SPREAD_SHEET_TABLE]
		do
			create Result
		end

end