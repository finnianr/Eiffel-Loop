note
	description: "String iteration cursor test SET"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 16:44:51 GMT (Saturday 5th April 2025)"
	revision: "8"

class
	STRING_ITERATION_CURSOR_TEST_SET

inherit
	ZSTRING_EQA_TEST_SET

	EL_SHARED_STRING_8_CURSOR

	EL_SHARED_STRING_32_CURSOR

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["status_query", agent test_status_query],
				["transforms", agent test_transforms]
			>>)
		end

feature -- Tests

	test_status_query
		-- STRING_ITERATION_CURSOR_TEST_SET.test_status_query
		note
			testing: "[
				covers/{EL_STRING_8_ITERATION_CURSOR}.is_ascii_substring,
				covers/{EL_STRING_8_ITERATION_CURSOR}.all_ascii,
				covers/{EL_STRING_8_ITERATION_CURSOR}.is_eiffel_lower,
				covers/{EL_STRING_8_ITERATION_CURSOR}.is_eiffel_upper
			]"
		do
			if attached padded_8 ('%T').shared_substring (2, 4) as abc then
				assert ("abc", abc.same_string ("abc"))
				assert ("is eiffel lower", cursor_8 (abc).is_eiffel_lower)
				assert ("is not eiffel upper", not cursor_8 (abc).is_eiffel_upper)
				assert ("is not eiffel title", not cursor_8 (abc).is_eiffel_title)
				assert ("is not eiffel title", not cursor_8 (abc.as_upper).is_eiffel_title)
				assert ("is eiffel title", cursor_8 ("Abc").is_eiffel_title)
			end
		end

	test_transforms
		note
			testing: "covers/{EL_STRING_8_ITERATION_CURSOR}.filtered"
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			assert ("is abc", cursor_8 (padded_8 ('%T')).filtered (agent c.is_a_to_z_lower) ~ "abc" )
		end

end