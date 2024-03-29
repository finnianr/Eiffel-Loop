note
	description: "[
		Finalized executable tests for library cluster [./library/markup-docs.thunderbird.html markup-docs.ecf#thunderbird]
	]"
	notes: "[
		Command option: `-thunderbird_autotest'
		
		**Test Sets**
		
			${THUNDERBIRD_EXPORT_TEST_SET}
	]"
	description: "[
		Finalized executable tests for library cluster [./library/markup-docs.thunderbird.html markup-docs.ecf#thunderbird]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "73"

class
	THUNDERBIRD_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [THUNDERBIRD_EXPORT_TEST_SET]
		redefine
			log_filter_set, visible_types
		end

create
	make

feature {NONE} -- Implementation

	visible_types: TUPLE [THUNDERBIRD_EXPORT_TEST_SET]
		do
			create Result
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, THUNDERBIRD_EXPORT_TEST_SET]
		do
			create Result.make
		end
end