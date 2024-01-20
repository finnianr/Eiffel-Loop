note
	description: "[
		Finalized executable tests for library cluster [./library/markup-docs.open_office.html markup-docs.ecf#open_office]
	]"
	notes: "[
		Command option: `-open_office_autotest'
		
		**Test Sets**
		
			${OPEN_OFFICE_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "20"

class
	OPEN_OFFICE_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [OPEN_OFFICE_TEST_SET]
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